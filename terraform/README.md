# GitHub Collaborators

This terraform code manages external collaborators on our GitHub repositories.

The intention is that all external collaborator relationships will be defined here, with the rationale for the collaborator(s) specified in the commit messages which add/remove them.

Collaborators who have been added to any of our repositories manually (i.e. they are not specified in code in this repository) will be automatically removed (nightly?).

## Pre-requisites

* Environment variables

See the [env.example](../env.example) file

* Terraform 0.13+

## Defining a repository

Before you can manage repository collaborators, you need to add a terraform file corresponding to the repository.

The filename should be `<repository name>.tf` with the following contents:

```
module "<repository name>" {
  source     = "./modules/repository"
  repository = "<repository name>"
  collaborators = {
  }
}
```

## Add collaborators

To add collaborators to the repository, define them inside the `collaborators` block like this:

```
    <github username> = "push" # pull|push|maintain|triage|admin
```

For example:

```
  collaborators = {
    digitalronin = "admin"
    l33thax0r    = "triage"
  }
```

## Import existing collaborators

If there are already external collaborators with access to the repository, and if you want them to continue to have access, they must be defined in the terraform file as above, and then imported into the terraform state.

```
terraform import module.<repository name>.github_repository_collaborator.collaborator[\"github username\"]>
```

## Add/Remove a collaborator

Once the repository is defined in terraform code, you can manage its collaborators by modifying the content of the `collaborators` map in the corresponding `<repository name>.tf` file.
