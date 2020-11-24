# GitHub External Collaborators

Manage MoJ GitHub external collaborators via code.

The terraform code manages external collaborators on our GitHub repositories.

The intention is that all external collaborator relationships will be defined here, with the rationale for the collaborator(s) specified in the commit messages which add/remove them.

Collaborators who have been added to any of our repositories manually (i.e. they are not specified in code in this repository) will be automatically removed (nightly?).

## Functions

* List all external collaborators with access to Ministry of Justice github repositories, and post the data to the [Operations Engineering Reports] web application
* Define external collaborators in terraform code
* Import pre-existing external collaborators from individual github repositories, create the corresponding terraform code and import into terraform state

## Managing collaborators

Before you can manage repository collaborators, you need to add a terraform file corresponding to the repository.

The filename should be `<repository name>.tf` with the following contents:

```
module "<repository name>" {
  source     = "./modules/repository-collaborators"
  repository = "<repository name>"
  collaborators = {
  }
}
```

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

You can, and should, add comments (prefixed with `#`) to these files describing who the collaborators are, and why they need access to the repository.

### Import existing collaborators

If you have a repository which already has collaborators, there is a utility script which will create the required terraform file and import the existing collaborators into the terraform state:

```
bin/import-repository-collaborators.rb
```

See the usage details below.

If you have manually added an external collaborator to a repository which is already defined in this repository, you should edit the terraform file as usual, but you will also need to import the existing collaborator into the terraform state like this:

```
terraform import module.<repository name>.github_repository_collaborator.collaborator[\"github username\"]> <repository name>:<github username>
```

e.g.

```
terraform import module.testing-external-collaborators.github_repository_collaborator.collaborator[\"toonsend\"] testing-external-collaborators:toonsend
```

## Pre-requisites

* [Terraform] 0.13+

### Environment Variables

* `ADMIN_GITHUB_TOKEN` must contain a GitHub personal access token (PAC) enabled for MoJ SSO, with the following scopes:
  * admin:org
  * repo
  * read:user
  * user:email

* `OPERATIONS_ENGINEERING_REPORTS_API_KEY` must contain the API key required to POST data to the [Operations Engineering Reports] web application.
* `OPS_ENG_REPORTS_URL` must contain the URL of the [Operations Engineering Reports] web application endpoint to which the generated JSON data should be POSTed.

* `TERRAFORM` must define the terraform executable (e.g. `/usr/local/bin/terraform0.13.5`)

See [env.example](./env.example) for more more information.

## Usage

### `bin/external-collaborators.rb`

This script is run on a schedule by a [github action](.github/workflows/post-data.yaml) You can also run it manually either by [triggering the action], or running locally like this:

```
bin/external-collaborators.rb
```

This outputs a JSON document suitable for POSTing to the [Operations Engineering Reports] web application.

You can also use the `bin/post-data.sh` script to generate and POST the JSON data manually.

#### Caveats

* Does not report any external collaborators who have not yet accepted their invitation to collaborate. Pending collaborators are not reported by the github graphql API.

### `bin/list-repositories.rb`

Output the names of all current (i.e. excluding deleted/archived/locked) MoJ github repositories.

### ` bin/import-repository-collaborators.rb`

This script takes a list of names of MoJ github repositories, and creates a file for each repository, in the `terraform` directory, defining all of that repository's external collaborators.

e.g. running

```
bin/import-repository-collaborators.rb acronyms`
```

...will create the file `terraform/acronyms.tf`

It also imports any existing collaborators into the terraform state.

### Import all repositories' collaborators

```
bin/list-repositories.rb | xargs bin/import-repository-collaborators.rb
```

> This takes quite a long time.

[Operations Engineering Reports]: https://github.com/ministryofjustice/operations-engineering-reports
[triggering the action]: https://github.com/ministryofjustice/operations-engineering-github-collaborators/actions?query=workflow%3A.github%2Fworkflows%2Fpost-data.yaml
[Terraform]: https://www.terraform.io/downloads.html
