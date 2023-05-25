# It is VERY important that the repo setting Actions > General > Fork pull request workflows from outside collaborators is set
# to "Require approval for first-time contributors"
import json
import os
import sys
import time
from github import Github

comment_message = """
  Hi there

  Thank you for creating a GitHub Collaborators pull request.

  Unfortunately the current process does not allow for pull requests from a forked repository due to security concerns.

  Please recreate this pull request from a branch, reach out to us on Slack at #ask-operations-engineering or create an issue on this repo with your requirements.

  This pull request will now be closed.

  Sorry for the inconvenience,

  Operations Engineering
"""

class PullRequestForked:
    def __init__(self, oauth_token, pr_json_data):
        self.oauth_token = oauth_token
        self.pr_json_data = pr_json_data

    def process_pull_request(self):
        if self.pr_json_data is None or self.oauth_token is None:
            print("Script input parameter is None")
            sys.exit()
        else:
            pr_is_fork = self.pr_json_data["head"]["repo"]["fork"]
            if pr_is_fork:
                try:
                    gh = Github(self.oauth_token)
                    repo_name = "ministryofjustice/" + self.pr_json_data["head"]["repo"]["name"]
                    repo = gh.get_repo(repo_name)
                    pull = repo.get_pull(self.pr_json_data["number"])
                    pull.create_issue_comment(comment_message)
                    # Delay for GH API
                    time.sleep(10)
                    pull.edit(state="closed")
                    return True
                except Exception as e:
                    print(e)
            else:
                return False

# Usage example
if __name__ == "__main__":
    oauth_token = os.getenv("TOKEN")
    pr_json_data = json.loads(os.getenv("PR_DATA"))

    print("Start")
    pr_processor = PullRequestForked(oauth_token, pr_json_data)
    pr_processor.process_pull_request()
    print("Finished")
    sys.exit(0)

