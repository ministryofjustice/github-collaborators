import sys
import time
import traceback
from datetime import datetime, timedelta
from ghapi.all import GhApi
from gql import gql, Client
from gql.transport.aiohttp import AIOHTTPTransport

# See https://ghapi.fast.ai/fullapi.html for the full ghapi library api calls.

# Get the GH Action token
oauth_token = sys.argv[1]

# Calculate the dates for API queries
today_date = datetime.now().isoformat()
from_date = (datetime.now() - timedelta(weeks=(9 * 4))).isoformat()


def print_stack_trace(message):
    """This will attempt to print a stack trace when an exception occurs

    Args:
        message ([type]): A message to print when exception occurs
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

# This is a list of usernames to ignore when adding users to the no-verified-domain-email team / repo
exception_list = ["houndci-bot"]

# The GH REST API interface
api = GhApi(
    owner="ministryofjustice",
    repo="no-verified-domain-email-repo",
    token=oauth_token,
)


def repo_issues_query(after_cursor=None) -> gql:
    """A GraphQL query to get the repo list of issues for no-verified-domain-email-repo

    Args:
        after_cursor ([type], optional): Is the pagination offset value gathered from the previous API request. Defaults to None.

    Returns:
        gql: The GraphQL query result
    """
    query = """
    {
        repository(name: "no-verified-domain-email-repo", owner: "ministryofjustice") {
            issues(first: 100, after:AFTER) {
                pageInfo {
                    endCursor
                    hasNextPage
                }
                edges {
                    node {
                        number
                        state
                        assignees(first: 10) {
                            edges {
                                node {
                                    login
                                }
                            }
                        }
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


def organisation_user_query(after_cursor=None) -> gql:
    """A GraphQL query to get the organisation users info

    Args:
        after_cursor ([type], optional): Is the pagination offset value gathered from the previous API request. Defaults to None.

    Returns:
        gql: The GraphQL query result
    """
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


def user_contribution_query(user_login=None) -> gql:
    """A GraphQL query to get the user contributions to the organisation in the last nine months

    Args:
        user_login ([type], optional): The user login name. Defaults to None.

    Returns:
        gql: The GraphQL query result
    """
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


def organisation_teams_name_query(after_cursor=None) -> gql:
    """A GraphQL query to get the list of organisation team names

    Args:
        after_cursor ([type], optional): Is the pagination offset value gathered from the previous API request. Defaults to None.

    Returns:
        gql: The GraphQL query result
    """
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


def team_repos_query(after_cursor=None, team_name=None) -> gql:
    """A GraphQL query to get the list of repos a team has access to in the organisation

    Args:
        after_cursor ([type], optional): Is the pagination offset value gathered from the previous API request. Defaults to None.
        team_name ([type], optional): Is the name of the team that has the associated repo/s. Defaults to None.

    Returns:
        gql: The GraphQL query result
    """
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


def team_user_names_query(after_cursor=None, team_name=None) -> gql:
    """A GraphQL query to get the list of user names within each organisation team.

    Args:
        after_cursor ([type], optional): Is the pagination offset value gathered from the previous API request. Defaults to None.
        team_name ([type], optional): Is the name of the team that has the associated user/s. Defaults to None.

    Returns:
        gql: The GraphQL query result
    """
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


def user_repo_contributions_query(after_cursor=None, user_login=None) -> gql:
    """A GraphQL query to get the list of repo/s a user has contributed to.

    Args:
        after_cursor ([type], optional): Is the pagination offset value gathered from the previous API request. Defaults to None.
        user_login ([type], optional): Is the name of the user. Defaults to None.

    Returns:
        gql: The GraphQL query result
    """
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


def fetch_users() -> list:
    """A wrapper function to run a GraphQL query to get the list of users within the organisation

    Returns:
        list: a list of users info within the organisation
    """
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


def fetch_repo_issues() -> list:
    """A wrapper function to run a GraphQL query to get the list of issues in a repo

    Returns:
        list: A list of issues for a repo
    """
    issue_list = []
    has_next_page = True
    after_cursor = None

    while has_next_page:
        query = repo_issues_query(after_cursor)
        data = client.execute(query)

        # Loop through the issues
        for issue in data["repository"]["issues"]["edges"]:
            issue_list.append(issue["node"])

        # Read the GH API page info section to see if there is more data to read
        has_next_page = data["repository"]["issues"]["pageInfo"]["hasNextPage"]
        after_cursor = data["repository"]["issues"]["pageInfo"]["endCursor"]

    return issue_list


def fetch_user_contribution_to_organisation(user_name) -> dict:
    """A wrapper function to run a GraphQL query to get the total contribution a user has made to the organisation

    Args:
        user_name ([type]): Is the name of the user

    Returns:
        dict: the metrics data that a user has contributed to the organisation
    """
    query = user_contribution_query(user_name)
    return client.execute(query)


def fetch_user_repo_contributions(user_name) -> list:
    """A wrapper function to run a GraphQL query to get the list of repo/s a user has contributed to

    Args:
        user_name ([type]): The user name of the user

    Returns:
        list: A list of repo names the user has contributed to
    """
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


def fetch_team_names() -> list:
    """A wrapper function to run a GraphQL query to get the list of teams in the organisation

    Returns:
        list: A list of the organisation repos names
    """
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


def fetch_team_users(team_name) -> list:
    """A wrapper function to run a GraphQL query to get the list of users within an organisation team

    Args:
        team_name ([type]): Is the team within the organisation to check

    Returns:
        list: A list of the team user names
    """
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


def fetch_team_repos(team_name) -> list:
    """A wrapper function to run a GraphQL query to get the list of repo within in an organisation team

    Args:
        team_name ([type]): Is the team within the organisation to check

    Returns:
        list: A list of team repo names
    """
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


class teams:
    """Basically a struct to store organisation team info ie name, users, repos"""

    team_name: str
    team_users: list
    team_repos: list

    def __init__(self, x, y, z):
        self.team_name = x
        self.team_users = y
        self.team_repos = z


def get_team(team_name) -> teams:
    """Gets the team info from GH

    Args:
        team_name ([type]): Name of the team

    Returns:
        teams: A teams object
    """
    team_users_list = fetch_team_users(team_name)
    team_repos_list = fetch_team_repos(team_name)
    return (teams(team_name, team_users_list, team_repos_list))


def fetch_teams() -> list:
    """Wrapper function to retrieve the organisation team info ie name, users, repos

    Returns:
        list: A list that contains all the organisation teams data ie name, users, repos
    """
    teams_list = []
    teams_names_list = fetch_team_names()
    for team_name in teams_names_list:
        teams_list.append(get_team(team_name))

    return teams_list


def has_user_contributed(user) -> bool:
    """A check to see if user has contributed to the organisation in the last nine months

    Args:
        user ([type]): Is the user to check

    Returns:
        bool: True if the user has contributed more than ten times in the last nine months
    """
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


def user_has_approved_email_domain(user) -> bool:
    """A check to see if the user has an approved email domain

    Args:
        user ([type]): Is the user to check

    Returns:
        bool: True if the user has an approved organisation email
    """
    user_email = user["organizationVerifiedDomainEmails"][0]
    user_email = user_email.lower()
    if (
        user_email.__contains__("@digital.justice.gov.uk")
        or user_email.__contains__("@justice.gov.uk")
        or user_email.__contains__("@cica.gov.uk")
        or user_email.__contains__("@hmcts.net")
    ):
        return True
    else:
        return False


def user_has_verified_email(user) -> bool:
    """A check to see if the user has an verified email with the organization

    Args:
        user ([type]): Is the user to check

    Returns:
        bool: True if the user has verified their email with the organisation
    """
    if user["organizationVerifiedDomainEmails"]:
        return True
    else:
        return False


def is_user_new(user) -> bool:
    """A check to see if the user is new to GH within a month

    Args:
        user ([type]): Is the user to check

    Returns:
        bool: True if the user has been created within a month
    """
    user_created_within_a_month = (datetime.now() - timedelta(weeks=4)).isoformat()
    if user["createdAt"] > user_created_within_a_month:
        return True
    else:
        return False


def print_warning_message(message, user):
    """Prints a warning message and related user info

    Args:
        message ([type]): Is the message to print
        user ([type]): Is the user to check
    """
    print(message)
    print("GH name: {0}".format(user["name"]))
    print("GH url: {0}".format(user["url"]))
    print("GH login: {0}".format(user["login"]))


def find_unverified_email_users(
    organisation_users_list, organisation_teams_list
) -> list:
    """Check a user is using the correct email domain and has a verified email address within their GH account

    Args:
        organisation_users_list ([type]): A list of the users within the organisation
        organisation_teams_list ([type]): A list of the teams within the organisation

    Returns:
        list: A list of the user usernames that do no have a correct email
    """
    non_approved_user_list = []

    for user in organisation_users_list:
        if user_has_verified_email(user) and not user_has_approved_email_domain(user):
            print_warning_message(
                "Warning: This user is using a non-approved email domain.", user
            )
            print(
                "Found email is: {0}".format(user["organizationVerifiedDomainEmails"])
            )
            print("\n")
            # Add this user to the return list
            non_approved_user_list.append(user["login"])
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
            # Add this user to the return list
            non_approved_user_list.append(user["login"])
    return non_approved_user_list


def close_issue(issue_number):
    """Close an issue within the no-verified-domain-email-repo

    Args:
        issue_number (bool): The issue to close
    """
    #
    api.issues.update(
        owner="ministryofjustice",
        repo="no-verified-domain-email-repo",
        issue_number=issue_number,
        state="closed",
    )
    # Delay for GH API
    time.sleep(5)


def close_repo_issues_for_user(repo_issues, user_name):
    """This will close an open issue/s for a particular user in the no-verified-domain-email-repo

    Args:
        repo_issues([type]): The list of repo issues in the no-verified-domain-email-repo
        user_name([type]): The user username
    """
    for issue in repo_issues:
        try:
            # Check issue is open
            if issue["state"] == "OPEN":
                # Check the user hasnt un-assigned themselves from the issue
                if issue["assignees"]["edges"]:
                    # Check issue is assigned to the user
                    if issue["assignees"]["edges"][0]["node"]["login"] == user_name:
                        close_issue(issue["number"])
                else:
                    # Found a un-assigned issue, close it, a new one for the user will be created in the future
                    close_issue(issue["number"])
        except Exception:
            message = "Warning: Exception in closing a no-verified-domain-email-repo issue for " + user_name
            print_stack_trace(message)
            # Back off from GH API
            time.sleep(30)


def remove_user_from_team_and_repo(team, unverified_email_users):
    """Removes the user from the no-verified-domain-email team and repo issue

    Args:
        team ([type]): The list of organisation teams
        unverified_email_users ([type]): The list of users that do not have a correct email domain or are not verified
    """

    # Get the no-verified-domain-email-repo issues list
    repo_issues = fetch_repo_issues()

    # Delete users in the no-verified-domain-email team that have verified there email address recently
    for user_name in team.team_users:
        if user_name in unverified_email_users:
            pass
            # The user hasnt verified an email yet so continue
        else:
            # Close any no-verified-domain-email-repo issue/s for the user
            close_repo_issues_for_user(repo_issues, user_name)

            # Remove the user from the no-verified-domain-email team as they are a verified user
            try:
                api.teams.remove_membership_for_user_in_org(
                    "ministryofjustice", "no-verified-domain-email", user_name
                )
                # Delay for GH API
                time.sleep(5)

                print(
                    "Removed the user from the no-verified-domain-email team: " + user_name
                )
                print("")

            except Exception:
                message = "Warning: Exception in removing a user from the no-verified-domain-email team: " + user_name
                print_stack_trace(message)
                # Back off from GH API
                time.sleep(30)


def create_an_issue(user_name):
    """Create an issue for the user within the no-verified-domain-email-repo

    Args:
        user_name ([type]): The username of the user to add to the no-verified-domain-email-repo issue
    """

    print(
        "Adding an issue to the no-verified-domain-email-repo for the user:" + user_name
    )

    try:
        api.issues.create(
            owner="ministryofjustice",
            repo="no-verified-domain-email-repo",
            title="Add your MoJ email address to your Github account",
            body="Your access to the ministryofjustice GitHub organisation will be revoked if you don't add a @digital.justice.gov.uk, @justice.gov.uk, @cica.gov.uk or @hmcts.net email address to your GitHub account. This is an automated process please do not change any settings, only make the email change in your settings area.",
            assignee=user_name,
        )
        # Delay for GH API
        time.sleep(5)
    except Exception:
        message = "Warning: Exception in creating an no-verified-domain-email-repo issue for " + user_name
        print_stack_trace(message)
        # Back off from GH API
        time.sleep(30)


def add_user_to_team_and_repo(team, unverified_email_users):
    """Add a user to the no-verified-domain-email team and the no-verified-domain-email-repo

    Args:
        team ([type]): The list of organisation teams
        unverified_email_users ([type]): The list of users that do not have a correct email domain or are not verified
    """
    for user_name in unverified_email_users:
        if user_name in team.team_users or user_name in exception_list:
            # User already in the team or on the exception list
            pass
        else:
            print("Adding the user to the no-verified-domain-email team: " + user_name)
            try:
                api.teams.add_or_update_membership_for_user_in_org(
                    "ministryofjustice",
                    "no-verified-domain-email",
                    user_name,
                    "member",
                )
                # Delay for GH API
                time.sleep(5)
            except Exception:
                message = "Warning: Exception in adding a user to the no-verified-domain-email team: " + user_name
                print_stack_trace(message)
                # Back off from GH API
                time.sleep(30)

            create_an_issue(user_name)


def get_issue_assigned_names(repo_issues) -> list:
    """Get the list of issues from the no-verified-domain-email-repo and create a list of the names of the assignees

    Args:
        repo_issues([type]): The list of repo issues in the no-verified-domain-email-repo

    Returns:
        list: The list of user usernames assigned to the issues in the repo
    """
    issue_assigned_names_list = []
    for issue in repo_issues:
        if issue["assignees"]["edges"]:
            if issue["state"] == "OPEN":
                issue_assigned_names_list.append(
                    issue["assignees"]["edges"][0]["node"]["login"]
                )
    return issue_assigned_names_list


def check_unverified_email_user_has_repo_issue(team):
    """Check an unverified email user has an issue in the no-verified-domain-email-repo and if not create one for them

    Args:
        team ([type]): The list of organisation teams
    """
    # Get the no-verified-domain-email-repo issues list
    repo_issues = fetch_repo_issues()
    issue_assigned_names_list = get_issue_assigned_names(repo_issues)

    # Check each team member has been assigned an issue within the repo
    for team_user in team.team_users:
        if team_user in issue_assigned_names_list:
            pass
            # User has an issue in the issue list
        else:
            create_an_issue(team_user)


def sanitize_repo_issue(organisation_users_list):
    """This checks no-verified-domain-email-repo list of issues for users that are no longer part of the organisation and closes those issues

    Args:
        organisation_users_list ([type]): The list of organisation user usernames
    """
    # Get the no-verified-domain-email-repo issues list
    repo_issues = fetch_repo_issues()
    issue_assigned_names_list = get_issue_assigned_names(repo_issues)

    organisation_user_name_list = []
    for organisation_user in organisation_users_list:
        organisation_user_name_list.append(organisation_user["login"])

    # Check each team member has been assigned an issue within the repo
    for user_name in issue_assigned_names_list:
        if user_name in organisation_user_name_list:
            pass
            # User is part of the organisation
        else:
            # User is not part of the organisation so close any no-verified-domain-email-repo issue/s for the user
            close_repo_issues_for_user(repo_issues, user_name)


def run():
    """A function for the main functionality of the script"""

    # Get the MoJ organisation teams and users info
    organisation_users_list = fetch_users()
    organisation_teams_list = fetch_teams()

    # Get the users that do not have a verified email address
    unverified_email_users = find_unverified_email_users(
        organisation_users_list, organisation_teams_list
    )

    # Remove the users that have updated a verified email address
    no_verified_domain_email_team = get_team("no-verified-domain-email")
    remove_user_from_team_and_repo(no_verified_domain_email_team, unverified_email_users)

    # Add the users that do not have a verified email address
    no_verified_domain_email_team = get_team("no-verified-domain-email")
    add_user_to_team_and_repo(no_verified_domain_email_team, unverified_email_users)

    # Check that every team member has an open issue in the repo
    no_verified_domain_email_team = get_team("no-verified-domain-email")
    check_unverified_email_user_has_repo_issue(no_verified_domain_email_team)
    
    # Check an open issue in the repo has an organisation user
    sanitize_repo_issue(organisation_users_list)


run()
print("Check Finished")
sys.exit(0)
