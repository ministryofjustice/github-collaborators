from datetime import datetime, timedelta
import sys
from gql import gql, Client
from gql.transport.aiohttp import AIOHTTPTransport

# Get the GH Action token
oauth_token = sys.argv[1]

today_date = datetime.now().isoformat()
from_date = (datetime.now() - timedelta(weeks=(9 * 4))).isoformat()

# Setup a transport and client to interact with the GH GraphQL API
try:
    transport = AIOHTTPTransport(
        url="https://api.github.com/graphql",
        headers={"Authorization": "Bearer {}".format(oauth_token)},
    )
except:
    print("Exception: Problem with the API URL or GH Token")

try:
    client = Client(transport=transport, fetch_schema_from_transport=False)
except:
    print("Exception: Problem with the Client.")


# A GraphQL query to get the organisation users info
# param: after_cursor is the pagination offset value gathered from the previous API request
# returns: the GraphQL query result
def organisation_user_query(after_cursor=None):
    query = """
    query {
        organization(login: "ministryofjustice") {
            membersWithRole(first: 100, after:AFTER) {
                edges {
                    node {
                        organizationVerifiedDomainEmails(login: "ministryofjustice")
                        login
                        name
                        url
                        createdAt
                    }
                }
                pageInfo {
                    endCursor
                    hasNextPage
                }
            }
        }
    }
    """.replace(
        # This is the next page ID to start the fetch from
        "AFTER",
        '"{}"'.format(after_cursor) if after_cursor else "null",
    )

    return gql(query)


# A GraphQL query to get the user contributions to the organisation in the last nine months
# param: user_login the user login name
# returns: the GraphQL query result
def user_contribution_query(user_login=None):
    query = (
        """
    query {
        user(login: USER_LOGIN) {
            contributionsCollection(from: FROM_DATE_TIME, to: TO_DATE_TIME, organizationID: "MDEyOk9yZ2FuaXphdGlvbjIyMDM1NzQ=") {
                totalPullRequestReviewContributions
                totalPullRequestContributions
                totalIssueContributions
                totalCommitContributions
            }
        }
    }
    """.replace(
            "USER_LOGIN",
            '"{}"'.format(user_login) if user_login else "null",
        )
        .replace(
            # Todays date
            "TO_DATE_TIME",
            '"{}"'.format(today_date),
        )
        .replace(
            # Todays date minus nine months
            "FROM_DATE_TIME",
            '"{}"'.format(from_date),
        )
    )

    return gql(query)


# A GraphQL query to get the list of organisation team names
# param: after_cursor is the pagination offset value gathered from the previous API request
# returns: the GraphQL query result
def organisation_teams_name_query(after_cursor=None):
    query = """
    query {
        organization(login: "ministryofjustice") {
            teams(first: 100, after:AFTER) {
                pageInfo {
                    endCursor
                    hasNextPage
                }
                edges {
                    node {
                        slug
                    }
                }
            }
        }
    }
        """.replace(
        # This is the next page ID to start the fetch from
        "AFTER",
        '"{}"'.format(after_cursor) if after_cursor else "null",
    )

    return gql(query)


# A GraphQL query to get the list of repos a team has access to in the organisation
# param: after_cursor is the pagination offset value gathered from the previous API request
# param: team_name is the name of the team that has the associated repo/s
# returns: the GraphQL query result
def team_repos_query(after_cursor=None, team_name=None):
    query = """
    query {
        organization(login: "ministryofjustice") {
            team(slug: TEAM_NAME) {
                repositories(first: 100, after:AFTER) {
                    edges {
                        node {
                            name
                        }
                    }
                    pageInfo {
                        endCursor
                        hasNextPage
                    }
                }
            }
        }
    }
    """.replace(
        # This is the next page ID to start the fetch from
        "AFTER",
        '"{}"'.format(after_cursor) if after_cursor else "null",
    ).replace(
        "TEAM_NAME",
        '"{}"'.format(team_name) if team_name else "null",
    )

    return gql(query)


# A GraphQL query to get the list of user names within each organisation team.
# param: after_cursor is the pagination offset value gathered from the previous API request
# param: team_name is the name of the team that has the associated user/s
# returns: the GraphQL query result
def team_user_names_query(after_cursor=None, team_name=None):
    query = """
    query {
        organization(login: "ministryofjustice") {
            team(slug: TEAM_NAME) {
                members(first: 100, after:AFTER) {
                    edges {
                        node {
                            login
                            name
                        }
                    }
                    pageInfo {
                        hasNextPage
                        endCursor
                    }
                }
            }
        }
    }
    """.replace(
        # This is the next page ID to start the fetch from
        "AFTER",
        '"{}"'.format(after_cursor) if after_cursor else "null",
    ).replace(
        "TEAM_NAME",
        '"{}"'.format(team_name) if team_name else "null",
    )

    return gql(query)


# A GraphQL query to get the list of repo/s a user has contributed to.
# param: after_cursor is the pagination offset value gathered from the previous API request
# param: user_login is the name of the user
# returns: the GraphQL query result
def user_repo_contributions_query(after_cursor=None, user_login=None):
    query = """
    query {
        user(login: USER_LOGIN) {
            repositoriesContributedTo(first: 100, after:AFTER) {
                edges {
                    node {
                        owner {
                            login
                        }
                        name
                    }
                }
                pageInfo {
                    hasNextPage
                    endCursor
                }
            }
        }
    }
    """.replace(
        # This is the next page ID to start the fetch from
        "AFTER",
        '"{}"'.format(after_cursor) if after_cursor else "null",
    ).replace(
        "USER_LOGIN",
        '"{}"'.format(user_login) if user_login else "null",
    )

    return gql(query)


# A wrapper function to run a GraphQL query to get the list of organisation users
# returns: a list of users info within the organisation
def fetch_users():
    users_list = []
    has_next_page = True
    after_cursor = None

    while has_next_page:
        query = organisation_user_query(after_cursor)
        data = client.execute(query)

        # Loop through the organization members
        for user in data["organization"]["membersWithRole"]["edges"]:
            users_list.append(user["node"])

        # Read the GH API page info section to see if there is more data to read
        has_next_page = data["organization"]["membersWithRole"]["pageInfo"][
            "hasNextPage"
        ]
        after_cursor = data["organization"]["membersWithRole"]["pageInfo"]["endCursor"]

    return users_list


# A wrapper function to run a GraphQL query to get the total contribution a user has made to the organisation
# param: user_name is the name of the user
# returns: the metrics data that a user has contributed to the organisation
def fetch_user_contribution_to_organisation(user_name):
    query = user_contribution_query(user_name)
    return client.execute(query)


# A wrapper function to run a GraphQL query to get the list of repo/s a user has contributed to
# param: user_name is the name of the user
# returns: a list of repo names the user has contributed to
def fetch_user_repo_contributions(user_name):
    has_next_page = True
    after_cursor = None
    repo_contribution_list = []

    while has_next_page:
        query = user_repo_contributions_query(after_cursor, user_name)
        data = client.execute(query)

        # Retrieve the repos the user has contributed to that are part of the organisation
        for repo in data["user"]["repositoriesContributedTo"]["edges"]:
            if repo["node"]["owner"]["login"] == "ministryofjustice":
                repo_contribution_list.append(repo["node"]["name"])

        # Read the GH API page info section to see if there is more data to read
        has_next_page = data["user"]["repositoriesContributedTo"]["pageInfo"][
            "hasNextPage"
        ]
        after_cursor = data["user"]["repositoriesContributedTo"]["pageInfo"][
            "endCursor"
        ]

    return repo_contribution_list


# A wrapper function to run a GraphQL query to get the list of teams in the organisation
# returns: a list of the organisation repos names
def fetch_team_names():
    has_next_page = True
    after_cursor = None
    team_name_list = []

    while has_next_page:
        query = organisation_teams_name_query(after_cursor)
        data = client.execute(query)

        # Retrieve the name of the teams
        for team in data["organization"]["teams"]["edges"]:
            team_name_list.append(team["node"]["slug"])

        # Read the GH API page info section to see if there is more data to read
        has_next_page = data["organization"]["teams"]["pageInfo"]["hasNextPage"]
        after_cursor = data["organization"]["teams"]["pageInfo"]["endCursor"]

    return team_name_list


# A wrapper function to run a GraphQL query to get the list of users within an organisation team
# param: team_name is the team within the organisation to check
# returns: a list of the team user names
def fetch_team_users(team_name):
    has_next_page = True
    after_cursor = None
    team_user_name_list = []

    while has_next_page:
        query = team_user_names_query(after_cursor, team_name)
        data = client.execute(query)

        # Retrieve the usernames of the team members
        for team in data["organization"]["team"]["members"]["edges"]:
            team_user_name_list.append(team["node"]["login"])

        # Read the GH API page info section to see if there is more data to read
        has_next_page = data["organization"]["team"]["members"]["pageInfo"][
            "hasNextPage"
        ]
        after_cursor = data["organization"]["team"]["members"]["pageInfo"]["endCursor"]

    return team_user_name_list


# A wrapper function to run a GraphQL query to get the list of repo within in an organisation team
# param: team_name is the team within the organisation to check
# returns: the list of team repo names
def fetch_team_repos(team_name):
    has_next_page = True
    after_cursor = None
    team_repo_list = []

    while has_next_page:
        query = team_repos_query(after_cursor, team_name)
        data = client.execute(query)

        # Retrieve the name of the teams repos
        for team in data["organization"]["team"]["repositories"]["edges"]:
            team_repo_list.append(team["node"]["name"])

        # Read the GH API page info section to see if there is more data to read
        has_next_page = data["organization"]["team"]["repositories"]["pageInfo"][
            "hasNextPage"
        ]
        after_cursor = data["organization"]["team"]["repositories"]["pageInfo"][
            "endCursor"
        ]

    return team_repo_list


# Basically a struct to store organisation team info ie name, users, repos
class teams:
    team_name: str
    team_users: list
    team_repos: list

    def __init__(self, x, y, z):
        self.team_name = x
        self.team_users = y
        self.team_repos = z


# Wrapper function to retrieve the organisation team info ie name, users, repos
# returns: all the organisation teams data ie name, users, repos
def fetch_teams():
    teams_list = []
    teams_names_list = fetch_team_names()
    for team_name in teams_names_list:
        team_users_list = fetch_team_users(team_name)
        team_repos_list = fetch_team_repos(team_name)
        teams_list.append(teams(team_name, team_users_list, team_repos_list))

    return teams_list


# A check to see if user has contributed to the organisation in the last nine months
# param: user is the user to check
# returns: Bool true is the user has contributed more than ten times in the last nine months
def has_user_contributed(user):
    data = fetch_user_contribution_to_organisation(user["login"])
    if (
        data["user"]["contributionsCollection"]["totalCommitContributions"] > 10
        or data["user"]["contributionsCollection"]["totalIssueContributions"] > 10
        or data["user"]["contributionsCollection"]["totalPullRequestContributions"] > 10
        or data["user"]["contributionsCollection"][
            "totalPullRequestReviewContributions"
        ]
        > 10
    ):
        return True
    else:
        return False


# A check to see if the user has an approved email domain
# param: user is the user to check
# returns: Bool true is the user has an approved organisation email
def user_has_approved_email_domain(user):
    user_email = user["organizationVerifiedDomainEmails"][0]
    user_email = user_email.lower()
    if (
        user_email.__contains__("@digital.justice.gov.uk")
        or user_email.__contains__("@justice.gov.uk")
        or user_email.__contains__("@cica.gov.uk")
    ):
        return True
    else:
        return False


# A check to see if the user has an verified email with the organization
# param: user is the user to check
# returns: Bool true is the user has verified their email with the organisation
def user_has_verified_email(user):
    if user["organizationVerifiedDomainEmails"]:
        return True
    else:
        return False


# A check to see if the user is new to GH within a month
# param: user is the user to check
# returns: Bool true is the user has been created within a month
def is_user_new(user):
    user_created_within_a_month = (datetime.now() - timedelta(weeks=4)).isoformat()
    if user["createdAt"] > user_created_within_a_month:
        return True
    else:
        return False


# Prints a warning message and related user info
# param: warning is the message to print
# param: user is the user to check
def print_warning_message(warning, user):
    print(warning)
    print("GH name: {0}".format(user["name"]))
    print("GH url: {0}".format(user["url"]))
    print("GH login: {0}".format(user["login"]))


# The main functionality is done here
def run():
    organisation_users_list = fetch_users()
    organisation_teams_list = fetch_teams()

    for user in organisation_users_list:
        if user_has_verified_email(user) and not user_has_approved_email_domain(user):
            print_warning_message(
                "Warning: This user is using a non-approved email domain.", user
            )
            print(
                "Found email is: {0}".format(user["organizationVerifiedDomainEmails"])
            )
            print("\n")
        elif not user_has_verified_email(user):
            if not has_user_contributed(user) and not is_user_new(user):
                print_warning_message(
                    "Warning: No email found for this user and the user has made minimal contributions to the organisation in the last nine months, consider changing the user into a collaborator?",
                    user,
                )
            else:
                print_warning_message("Warning: No email found for this user.", user)

            # Print the name of the repos for each team the user is a member of
            for team in organisation_teams_list:
                if user["login"] in team.team_users:
                    print(
                        "The user is a member of the team: {0}".format(team.team_name)
                    )
                    if team.team_repos:
                        print("That team has access to these repos:")
                        for repo in team.team_repos:
                            print("\t" + repo)

            # Print the repo/s the user has contributed to within the organisation
            user_repo_contributions = fetch_user_repo_contributions(user["login"])
            if user_repo_contributions:
                print("The user has contributed to these repos:")
                for repo in user_repo_contributions:
                    print("\t" + repo)
            print("\n")


run()
print("Check Finished")
sys.exit(0)
