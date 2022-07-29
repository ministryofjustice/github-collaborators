import sys
import traceback
from github import Github

MINISTRYOFJUSTICE = "ministryofjustice/"

if len(sys.argv) == 4:
    # Get the GH Action token
    oauth_token = sys.argv[1]
    repository = sys.argv[2]
    github_user = sys.argv[3]
else:
    print("Missing a script input parameter")
    sys.exit(1)


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


def create_an_issue(user_name, repository_name):
    """Create an issue on a repository
    Args:
        user_name (string): The username of the user
        repository_name (string): The name of the repository
    """
    try:
        gh = Github(oauth_token)
        repo = gh.get_repo(MINISTRYOFJUSTICE + repository_name)
        if repo.has_issues:
            repo.create_issue(
                title="Collaborator Removed",
                body="Hi there \n\n The collaborator " + user_name +
                " has been removed from this repository. \n\n If you have any questions, please post in #ask-operations-engineering on Slack. \n\n This issue can be closed.",
                assignee=user_name,)
    except Exception:
        message = ("Warning: Exception in creating an issue for user " +
                   user_name + " in the repository: " + repository_name)
        print_stack_trace(message)


def remove_user_from_repository(user_name, repository_name):
    """Removes the user from the repository
    Args:
        user_name (string): User name of the user to remove
        repository_name (string): Name of repository
    """
    try:
        gh = Github(oauth_token)
        repo = gh.get_repo(MINISTRYOFJUSTICE + repository_name)
        repo.remove_from_collaborators(user_name)
        print("Removing the user " + user_name +
              " from the repository: " + repository_name)
    except Exception:
        message = ("Warning: Exception in removing a user " +
                   user_name + " from the repository: " + repository_name)
        print_stack_trace(message)


def run():
    create_an_issue(github_user, repository)
    remove_user_from_repository(github_user, repository)


print("Start")
run()
print("Finished")
sys.exit(0)
