from github import Github
from gql import gql, Client
from gql.transport.aiohttp import AIOHTTPTransport
import sys
import traceback
import time

# Get the GH Action token
oauth_token = sys.argv[1]


def print_stack_trace(message):
    """Print a stack trace when an exception occurs

    Args:
        message (string): A message to print when exception occurs
    """
    print(message)
    try:
        exc_info = sys.exc_info()
    finally:
        traceback.print_exception(*exc_info)
        del exc_info


# Setup a transport and client to interact with the GH GraphQL API
try:
    transport = AIOHTTPTransport(
        url="https://api.github.com/graphql",
        headers={"Authorization": "Bearer {}".format(oauth_token)},
    )
except Exception:
    print_stack_trace("Exception: Problem with the API URL or GH Token")

try:
    client = Client(transport=transport, fetch_schema_from_transport=False)
except Exception:
    print_stack_trace("Exception: Problem with the Client.")


def repository_query(after_cursor=None, repo_name=None) -> gql:
    """A GraphQL query to get the list of outside collaborator in a repo and the locked status

    Args:
        after_cursor (string, optional): Is the pagination offset value gathered from the previous API request. Defaults to None.
        repo_name (string, optional): Is the name of the repository. Defaults to None.

    Returns:
        gql: The GraphQL query result
    """
    query = """
    {
        repository(
            name: REPO_NAME
            owner: "ministryofjustice"
        ) {
            collaborators(first: 100, affiliation: OUTSIDE, after:AFTER) {
                edges {
                    node {
                        login
                    }
                }
                pageInfo {
                    endCursor
                    hasNextPage
                }
            }
            isDisabled
            isArchived
            isLocked
        }
    }
    """.replace(
        # This is the next page ID to start the fetch from
        "AFTER",
        '"{}"'.format(after_cursor) if after_cursor else "null",
    ).replace(
        "REPO_NAME",
        '"{}"'.format(repo_name) if repo_name else "null",
    )

    return gql(query)


def fetch_repository_data(repository_name) -> tuple:
    """A wrapper function to run a GraphQL query to get the list of outside collaborators of a repository and locked status

    Args:
        repository_name (string): Is the repository within the organisation to check

    Returns:
        list: A list of the repository user names
        is_repository_locked: Lock status of the repository
    """
    has_next_page = True
    after_cursor = None
    collaborators_list = []
    is_repository_locked = False

    while has_next_page:
        query = repository_query(after_cursor, repository_name)
        data = client.execute(query)

        # Retrieve the collaborators
        for repository in data["repository"]["collaborators"]["edges"]:
            collaborators_list.append(repository["node"]["login"])

        # Read the GH API page info section to see if there is more data to read
        has_next_page = data["repository"]["collaborators"]["pageInfo"]["hasNextPage"]
        after_cursor = data["repository"]["collaborators"]["pageInfo"]["endCursor"]

        # Determine lock status
        if (
            data["repository"]["isDisabled"]
            or data["repository"]["isArchived"]
            or data["repository"]["isLocked"]
        ):
            is_repository_locked = True

    return collaborators_list, is_repository_locked


class repository:
    """A struct to store repository info ie name, collaborators, locked status"""

    name: str
    collaborators: list
    is_repository_locked: bool

    def __init__(self, x, y, z):
        self.name = x
        self.collaborators = y
        self.is_repository_locked = z


def fetch_repository_names() -> list:
    """Get the list of repository names in the organisation via REST API

    Returns:
        list: A list of the organisation repository names
    """
    repo_name_list = []

    gh = Github(oauth_token)
    org = gh.get_organization("ministryofjustice")
    for repo in org.get_repos():
        repo_name_list.append(repo.name)

    return repo_name_list


def fetch_repositories() -> list:
    """Wrapper function to retrieve the repositories info ie name, collaborators, locked status

    Returns:
        list: A list that contains all the repositories data ie name, users, locked status
    """
    repositories_list = []
    for repository_name in fetch_repository_names():
        collaborators_list, is_repository_locked = fetch_repository_data(
            repository_name
        )
        time.sleep(1)
        repositories_list.append(
            repository(repository_name, collaborators_list,
                       is_repository_locked)
        )

    return repositories_list


def remove_collaborator(collaborator):
    """Remove the collaborator from the organisation

    Args:
        collaborator (collaborator): The collaborator object
    """
    print("Remove user from organisation: " + collaborator.login)
    gh = Github(oauth_token)
    org = gh.get_organization("ministryofjustice")
    org.remove_outside_collaborator(collaborator)


def run():
    repositories = fetch_repositories()
    gh = Github(oauth_token)
    org = gh.get_organization("ministryofjustice")
    # for each collaborator, check if all their repositories are locked
    for outside_collaborator in org.get_outside_collaborators():
        collaborators_repo_list = []
        for repository in repositories:
            if outside_collaborator.login in repository.collaborators:
                collaborators_repo_list.append(repository.is_repository_locked)
        an_open_repo = False
        if an_open_repo not in collaborators_repo_list:
            # all repositories are locked so remove the collaborator
            remove_collaborator(outside_collaborator)


print("Start")
run()
print("Finished")
sys.exit(0)
