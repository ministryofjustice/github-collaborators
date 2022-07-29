import json
import requests
import sys
from github import Github

if len(sys.argv) == 3:
    # Get the GH Action token
    base_branch_sha = sys.argv[1]
    head_branch_sha = sys.argv[2]
else:
    print("Missing a script input parameter")
    sys.exit()


def get_git_diff():
    # Get the merge diff results using the git sha of the base branch and the new branch. The filter checks for files that have
    # been added, modified, etc and filters out deleted changes. It will put the result into a pipe to be used with grep below.
    ps = subprocess.Popen(('git', 'diff', '-U0', '--diff-filter=ACMRT', head_branch_sha[0:7], base_branch_sha[0:7]), stdout=subprocess.PIPE)
    ps.wait()
    # The diff will return a string value if there were changes.
    if ps.stdout != "":
        # Need a try exception block here because grep returns a negative result if it doesn't find the expected value.
        try:
            # Look for the 'added_by' line in the diff results
            grep_output = subprocess.check_output(('grep', 'github_user'), stdin=ps.stdout, text=True)
        except:
            # Grep didn't find an 'added_by' line, check finished.
            print("Check N/A")
            sys.exit(0)
        else:
            print(grep_output)


def run():
    # git diff-tree -r --no-commit-id --name-only --diff-filter=ACMRT $base_branch_sha $head_branch_sha > modified_files.txt
    get_git_diff()
    username = "NickWalt01"
    api_url = "https://api.github.com/users/" + username
    response = requests.get(api_url)
    if username in response.text:
        print("found user")


print("Start")
run()
print("Finished")
sys.exit(0)
