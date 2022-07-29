import os
import sys
import traceback
from github import Github

if len(sys.argv) == 2:
    # Get the GH Action token
    oauth_token = sys.argv[1]
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


class Repository:
    """A struct to store repository info ie name, users, invites, etc"""

    name: str
    collaborators: list
    pending_invitations: list

    def __init__(self, x, y, z):
        self.name = x
        self.collaborators = y
        self.pending_invitations = z


def get_terraform_repositories() -> list:
    """Read the data from the terraforms files in this repository

    Returns:
        list: Repository objects containing the repositories data
    """
    repositories_list = []
    exclude_files = set(
        ["main.tf", "variables.tf", "versions.tf", "backend.tf", "main.tf"]
    )
    for _, _, files in os.walk("terraform", topdown=True):
        files[:] = [f for f in files if f not in exclude_files]
        for filename in files:
            collaborators_list = []
            filepath = "terraform/" + filename
            end = filename.find(".")
            repository_name = filename[:end]
            with open(filepath) as f:
                data = f.readlines()
            for line in data:
                if 'github_user  = "' in line:
                    start = line.find('"')
                    start += 1
                    end = line.find('"', start)
                    username = line[start:end]
                    collaborators_list.append(username)
            if repository_name == "MOJ-PTTP-DevicesAndApps-Pipeline-Windows10Apps":
                repository_name = "MOJ.PTTP.DevicesAndApps.Pipeline.Windows10Apps"
            repositories_list.append(Repository(
                repository_name, collaborators_list, _))
    return repositories_list


def get_outside_collaborators() -> list:
    """Create a list of the Outside Collaborators usernames

    Returns:
        list: The Outside Collaborators usernames
    """
    usernames = []
    try:
        gh = Github(oauth_token)
        org = gh.get_organization("ministryofjustice")
        for outside_collaborator in org.get_outside_collaborators():
            usernames.append(outside_collaborator.login)
    except Exception:
        message = "Warning: Exception in getting Outside Collaborators in get_outside_collaborators()"
        print_stack_trace(message)

    return usernames


def get_github_repositories(terraform_repositories) -> Repository:
    """Get the Github repositories data ie name, collaborators, pending invites

    Args:
        terraform_repositories (list): Repository objects representing Terraform data

    Returns:
        list: Repository objects representing GitHub data
    """
    repositories_list = []
    outside_collaborators = get_outside_collaborators()
    try:
        gh = Github(oauth_token)
        org = gh.get_organization("ministryofjustice")
        for repository in terraform_repositories:
            collaborators_list = []
            pending_invitations = []
            repo = org.get_repo(repository.name)
            for invite in repo.get_pending_invitations():
                pending_invitations.append(invite.invitee.login)
            for collaborator in repo.get_collaborators():
                if collaborator.login in outside_collaborators:
                    collaborators_list.append(collaborator.login)
            repositories_list.append(
                Repository(repository.name, collaborators_list,
                           pending_invitations)
            )
    except Exception:
        message = (
            "Warning: Exception in getting github data in get_github_repositories()"
        )
        print_stack_trace(message)

    return repositories_list


def get_collaborators_also_org_members(terraform_repositories) -> list:
    """Find collaborators defined in Terraform repositories that are also members of the organization

    Args:
        terraform_repositories (list): Repository objects representing Terraform data

    Returns:
        list: The usernames of Outside Collaborators that have full organisation membership
    """
    full_members = {""}
    try:
        gh = Github(oauth_token)
        org = gh.get_organization("ministryofjustice")
        for member in org.get_members():
            for repo in terraform_repositories:
                if member.login in repo.collaborators:
                    full_members.add(member.login)
    except Exception:
        message = "Warning: Exception in get_collaborators_also_org_members()"
        print_stack_trace(message)
    return list(set(full_members))


def compare_repositories(terraform_repositories, github_repositories):
    """Compare the  Outside Collaborators within a repository from Terraform and GitHub sources.

    Args:
        terraform_repositories (list): Repository objects representing Terraform data
        github_repositories (list): Repository objects representing GitHub data
    """
    full_org_collaborators = get_collaborators_also_org_members(
        terraform_repositories)
    for terraform_repository in terraform_repositories:
        for github_repository in github_repositories:
            if terraform_repository.name == github_repository.name:
                if len(terraform_repository.collaborators) != len(github_repository.collaborators):
                    print("=====================================")
                    print("Difference in repository: " +
                          terraform_repository.name)
                    print("Number of Outside Collaborators defined in Terraform: " +
                          len(terraform_repository.collaborators).__str__())
                    print("Number of Outside Collaborators on GitHub: " +
                          len(github_repository.collaborators).__str__())
                    if len(terraform_repository.collaborators) > len(github_repository.collaborators):
                        print(
                            "These Outside Collaborator/s are not present on GitHub:")
                        for (terraform_collaborator) in terraform_repository.collaborators:
                            if (terraform_collaborator not in github_repository.collaborators):
                                if (terraform_collaborator in github_repository.pending_invitations):
                                    print(terraform_collaborator +
                                          ": Has a pending invite or Invite expired")
                                elif terraform_collaborator in full_org_collaborators:
                                    print(terraform_collaborator +
                                          ": Has full organization membership")
                                else:
                                    print(terraform_collaborator)
                    elif len(github_repository.collaborators) > len(terraform_repository.collaborators):
                        print(
                            "These Outside Collaborator/s are not defined in Terraform:")
                        for github_collaborator in github_repository.collaborators:
                            if github_collaborator not in terraform_repository.collaborators:
                                print(github_collaborator)
                    print("=====================================")
                    print("")


def run():
    terraform_repositories = get_terraform_repositories()
    github_repositories = get_github_repositories(terraform_repositories)
    compare_repositories(terraform_repositories, github_repositories)


print("Start")
run()
print("Finished")
sys.exit(0)
