# It is VERY important that the repo setting Actions > General > Fork pull request workflows from outside collaborators is set
# to "Require approval for first-time contributors"
import sys
import time
from github import Github

oauth_token = 0
pr_json_data = None

if len(sys.argv) == 3:
    pr_json_data = sys.argv[1]
    oauth_token = sys.argv[2]
else:
    print("Missing a script input parameter")
    sys.exit()

comment_message = """
  Hi there

  Thank you for creating a GitHub Collaborators pull request.

  Unfortunately the current process does not allow for pull requests from a forked repository due to security concerns.

  Please recreate this pull request from a branch, reach out to us on Slack at #ask-operations-engineering or create an issue on this repo with your requirements.

  This pull request will now be closed.

  Sorry for the inconvenience,

  Operations Engineering
"""


def run():
    if pr_json_data["head"]["repo"]["fork"] is not None:
        pr_is_fork = pr_json_data["head"]["repo"]["fork"]
        if pr_is_fork:
            try:
                gh = Github(oauth_token)
                repo = gh.get_repo(pr_json_data["head"]["repo"]["name"])
                pull = repo.get_pull(pr_json_data["number"])
                pull.create_issue_comment(comment_message)
                # Delay for GH API
                time.sleep(10)
                pull.edit(state="closed")
            except Exception as e:
                print(e)


print("Start")
run()
print("Finished")
sys.exit(0)
