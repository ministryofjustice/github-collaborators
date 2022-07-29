import requests
import sys
from github import Github

if len(sys.argv) == 2:
    # Get the GH Action token
    oauth_token = sys.argv[1]
else:
    print("Missing a script input parameter")
    sys.exit()


def get_collaborator_names() -> list:
    """Get the names of collaborators in the .tf files that changed in PR

    Returns:
        list: usernames of collaborators
    """
    collaborator_names = {""}
    collaborator_names.pop()
    with open("modified_files.txt") as f:
        filenames = f.readlines()
    for filename in filenames:
        if ".tf" in filename:
            filename = filename[:filename.find("\n")]
            with open(filename) as f:
                lines = f.readlines()
            for line in lines:
                if 'github_user  = "' in line:
                    start = line.find('"')
                    start += 1
                    end = line.find('"', start)
                    username = line[start:end]
                    collaborator_names.add(username)
    return list(set(collaborator_names))


def run():
    collaborators = get_collaborator_names()
    for collaborator in collaborators:
        api_url = "https://api.github.com/users/" + collaborator
        headers = {'Authorization': oauth_token}
        response = requests.get(api_url, headers=headers)
        if collaborator not in response.text:
            print("User not found: " + collaborator)
            sys.exit(1)


print("Start")
run()
print("Finished")
sys.exit(0)
