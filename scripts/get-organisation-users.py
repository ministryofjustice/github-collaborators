from dataclasses import dataclass
from datetime import datetime, timedelta
import sys
from gql import gql, Client
from gql.transport.aiohttp import AIOHTTPTransport

# Get the GH Action token
oauth_token = sys.argv[1]

# Setup a transport to the GH GraphQL API
try:
    transport = AIOHTTPTransport(
        url="https://api.github.com/graphql",
        headers={"Authorization": "Bearer {}".format(oauth_token)},
    )
except:
    print("Exception: Problem with the API URL or GH Token")


# Creates a GraphQL query with a pagination offset value
# param: after_cursor is the pagination offset value gathered from the previous API request
# returns: the GraphQL query that will be used
def organisation_user_query(today_date, from_date, after_cursor=None):
    query = (
        """
    query {
    organization(login: "ministryofjustice") {
        membersWithRole(first: 15, after:AFTER) {
        edges {
            node {
            organizationVerifiedDomainEmails(login: "ministryofjustice")
            login
            name
            url
            contributionsCollection(from: FROM_DATE_TIME, to: TO_DATE_TIME, organizationID: "MDEyOk9yZ2FuaXphdGlvbjIyMDM1NzQ=") {
                totalCommitContributions
                totalIssueContributions
                totalPullRequestContributions
                totalPullRequestReviewContributions
            }
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
            # This is the next page user ID to start the fetch from
            "AFTER",
            '"{}"'.format(after_cursor) if after_cursor else "null",
        )
        .replace(
            # Today date
            "TO_DATE_TIME",
            '"{}"'.format(today_date) if today_date else "null",
        )
        .replace(
            # Today date minus nine months, this is max grace period a user has to contribute to the organisation repos
            "FROM_DATE_TIME",
            '"{}"'.format(from_date) if from_date else "null",
        )
    )

    return gql(query)


# A GraphQL query to get the list of organisation team names
def organisation_teams_name_query(after_cursor=None):
    query = """
{
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
        # This is the next page team ID to start the fetch from
        "AFTER",
        '"{}"'.format(after_cursor) if after_cursor else "null",
    )

    return gql(query)


# A GraphQL query to get the list of repos a team has access to.
def team_repos_query(after_cursor=None, team_name=None):
    query = """
{
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


# A GraphQL query to get the list of users in a team.
def team_user_names_query(after_cursor=None, team_name=None):
    query = """
{
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


# A GraphQL query to get the list of repo a user has contributed to.
def user_repo_contributions_query(after_cursor=None, user_name=None):
    query = """
{
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
        '"{}"'.format(user_name) if user_name else "null",
    )

    return gql(query)


def fetch_user_repo_contributions(username):
    has_next_page = True
    after_cursor = None
    repo_contribution_list = []

    try:
        client = Client(transport=transport, fetch_schema_from_transport=False)

        while has_next_page:
            query = user_repo_contributions_query(after_cursor, username)
            data = client.execute(query)

            # Loop through the repos the user has contributed to that are part of the organisation
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

    except:
        print(
            "Exception: Problem with the GH API call in fetch_user_repo_contributions()"
        )

    return repo_contribution_list


def fetch_team_names():
    has_next_page = True
    after_cursor = None
    team_name_list = []

    try:
        client = Client(transport=transport, fetch_schema_from_transport=False)

        while has_next_page:
            query = organisation_teams_name_query(after_cursor)
            data = client.execute(query)

            # Loop through the organization members
            for team in data["organization"]["teams"]["edges"]:
                team_name_list.append(team["node"]["slug"])

            # Read the GH API page info section to see if there is more data to read
            has_next_page = data["organization"]["teams"]["pageInfo"]["hasNextPage"]
            after_cursor = data["organization"]["teams"]["pageInfo"]["endCursor"]

    except:
        print("Exception: Problem with the GH API call in fetch_team_names()")

    return team_name_list


def fetch_team_users(team_name):
    has_next_page = True
    after_cursor = None
    team_user_name_list = []

    try:
        client = Client(transport=transport, fetch_schema_from_transport=False)

        while has_next_page:
            query = team_user_names_query(after_cursor, team_name)
            data = client.execute(query)

            # Loop through the organization members
            for team in data["organization"]["team"]["members"]["edges"]:
                team_user_name_list.append(team["node"]["login"])

            # Read the GH API page info section to see if there is more data to read
            has_next_page = data["organization"]["team"]["members"]["pageInfo"][
                "hasNextPage"
            ]
            after_cursor = data["organization"]["team"]["members"]["pageInfo"][
                "endCursor"
            ]

    except:
        print("Exception: Problem with the GH API call in fetch_team_users()")

    return team_user_name_list


def fetch_team_repos(team_name):
    has_next_page = True
    after_cursor = None
    team_repo_list = []

    try:
        client = Client(transport=transport, fetch_schema_from_transport=False)

        while has_next_page:
            query = team_repos_query(after_cursor, team_name)
            data = client.execute(query)

            # Loop through the organization members
            for team in data["organization"]["team"]["repositories"]["edges"]:
                team_repo_list.append(team["node"]["name"])

            # Read the GH API page info section to see if there is more data to read
            has_next_page = data["organization"]["team"]["repositories"]["pageInfo"][
                "hasNextPage"
            ]
            after_cursor = data["organization"]["team"]["repositories"]["pageInfo"][
                "endCursor"
            ]

    except:
        print("Exception: Problem with the GH API call in fetch_team_repos()")

    return team_repo_list


class teams:
    team_name: str
    team_users: list
    team_repos: list

    def __init__(self, x, y, z):
        self.team_name = x
        self.team_users = y
        self.team_repos = z


def fetch_teams():
    teams_list = []
    teams_names_list = fetch_team_names()
    for team_name in teams_names_list:
        team_users_list = fetch_team_users(team_name)
        team_repos_list = fetch_team_repos(team_name)
        teams_list.append(teams(team_name, team_users_list, team_repos_list))

    return teams_list


def fetch_users():
    unverified_users = []
    non_approved_email_domain_users = []
    minimal_user_activity_list = []
    has_next_page = True
    after_cursor = None
    today_date = datetime.now().isoformat()
    from_date = (datetime.now() - timedelta(weeks=(9 * 4))).isoformat()

    try:
        client = Client(transport=transport, fetch_schema_from_transport=False)

        while has_next_page:
            query = organisation_user_query(today_date, from_date, after_cursor)
            data = client.execute(query)

            # Loop through the organization members
            for user in data["organization"]["membersWithRole"]["edges"]:
                # Look for users that have minimal activity in the last nine months
                if not (
                    user["node"]["contributionsCollection"]["totalCommitContributions"]
                    > 10
                    or user["node"]["contributionsCollection"][
                        "totalIssueContributions"
                    ]
                    > 10
                    or user["node"]["contributionsCollection"][
                        "totalPullRequestContributions"
                    ]
                    > 10
                    or user["node"]["contributionsCollection"][
                        "totalPullRequestReviewContributions"
                    ]
                    > 10
                ):
                    minimal_user_activity_list.append(user["node"])

                # Check user has an verified email with the organization
                if not user["node"]["organizationVerifiedDomainEmails"]:
                    unverified_users.append(user["node"])
                else:
                    # Check verified email users are using an approved email domain
                    user_email = user["node"]["organizationVerifiedDomainEmails"][0]
                    user_email = user_email.lower()
                    if not (
                        user_email.__contains__("@digital.justice.gov.uk")
                        or user_email.__contains__("@justice.gov.uk")
                        or user_email.__contains__("@cica.gov.uk")
                    ):
                        non_approved_email_domain_users.append(user["node"])

            # Read the GH API page info section to see if there is more data to read
            has_next_page = data["organization"]["membersWithRole"]["pageInfo"][
                "hasNextPage"
            ]
            after_cursor = data["organization"]["membersWithRole"]["pageInfo"][
                "endCursor"
            ]

    except:
        print("Exception: Problem with the GH API call.")

    return unverified_users, non_approved_email_domain_users, minimal_user_activity_list


def print_output():
    (
        unverified_users,
        non_approved_email_domain_users,
        minimal_user_activity_list,
    ) = fetch_users()

    teams_list = fetch_teams()

    user_created_within_a_month = (datetime.now() - timedelta(weeks=4)).isoformat()
    for user in minimal_user_activity_list:

        # This check is to allow new users one month to contribute to the organisation
        if user["createdAt"] > user_created_within_a_month:
            continue

        if user in unverified_users:
            print(
                "Warning: No email found for user and the user has made minimal contributions to the organisation in the last nine months, consider changing the user into a collaborator?".format(
                    user["name"]
                )
            )
            unverified_users.remove(user)
            print("GH name: {0}".format(user["name"]))
            print("GH url: {0}".format(user["url"]))
            print("GH login: {0}".format(user["login"]))

            for team in teams_list:
                if user["login"] in team.team_users:
                    print(
                        "The user is a member of the team: {0}".format(team.team_name)
                    )
                    if team.team_repos:
                        print("That team has access to these repos:")
                        for repo in team.team_repos:
                            print("\t" + repo)

            user_repo_contributions = fetch_user_repo_contributions(user["login"])
            if user_repo_contributions:
                print("The user has contributed to these repos:")
                for repo in user_repo_contributions:
                    print("\t" + repo)
            print("")
            print("")

    for user in unverified_users:
        print("Warning: No email found for this user.")
        print("GH name: {0}".format(user["name"]))
        print("GH url: {0}".format(user["url"]))
        print("GH login: {0}".format(user["login"]))

        for team in teams_list:
            if user["login"] in team.team_users:
                print("The user is a member of the team: {0}".format(team.team_name))
                if team.team_repos:
                    print("That team has access to these repos:")
                    for repo in team.team_repos:
                        print("\t" + repo)

        user_repo_contributions = fetch_user_repo_contributions(user["login"])
        if user_repo_contributions:
            print("The user has contributed to these repos:")
            for repo in user_repo_contributions:
                print("\t" + repo)
        print("")
        print("")

    for user in non_approved_email_domain_users:
        print(
            "Warning: This user is using a non-approved email domain: {0}".format(
                user["name"]
            )
        )
        print("GH url is {0}".format(user["url"]))
        print("GH login is {0}".format(user["login"]))
        print("Found email is : {0}".format(user["organizationVerifiedDomainEmails"]))
        print("")
        print("")


print_output()

print("Check Finished")
sys.exit(0)
