# GitHub External Collaborators

Manage MoJ GitHub external collaborators via code.

The terraform code manages external collaborators on our GitHub repositories.

The intention is that all external collaborator relationships will be defined here, along with the rationale for the collaboration.

> Collaborators who are not defined in the terraform code here in sufficient detail (i.e. so that we know why they have access to a repository, who gave it to them, and when it should be reviewed) will be automatically removed.

## Functions

* Define external collaborators in terraform code
* List all external collaborators with access to Ministry of Justice github repositories, where there is insufficient detail defined in the terraform code here, and post the data to the [Operations Engineering Reports] web application
* Import pre-existing external collaborators from individual github repositories, create the corresponding terraform code and import into terraform state

## Defining collaborators

To define collaborators on a repository, first add a terraform file corresponding to the repository (unless there already is one).

The filename should be `<repository-name>.tf` where `repository-name` is the repository name **with any `.` characters replaced by `-`**

The file should contain:

```
module "<repository-name>" {
  source     = "./modules/repository-collaborators"
  repository = "<repository.name>"
  collaborators = [
  ]
}
```

> The value of `repository` inside the file should be the exact name of the repository, with no substitutions. i.e. if the repository is called `ministryofjustice/foo.bar` then put `repository = "foo.bar"`

To add collaborators to the repository, define each of them inside the `collaborators` block, with the following information inside the quotation marks:

```
    {
      github_user  = "<github username>"
      permission   = "push"  #  pull|push|maintain|triage|admin
      name         = ""  #  The name of the person behind github_user
      email        = ""  #  Their email address
      org          = ""  #  The organisation/entity they belong to
      reason       = ""  #  Why is this person being granted access?
      added_by     = ""  #  Who made the decision to grant them access? e.g. "Some Person <some.person@digital.justice.gov.uk>"
      review_after = ""  #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
```

For example:

```
  collaborators = [
    {
      github_user  = "digitalronin"
      permission   = "admin"
      name         = "David Salgado"
      email        = "david@acme.com"
      org          = "Acme. Corp."
      reason       = "Acme are building some stuff for us"
      added_by     = "Steve Marshall <steve@fake-email.gov.uk>"
      review_after = "2021-11-26"
    },
  ]
```

You can add comments (prefixed with `#` on every line) to these files to provide additional context/information.

### Import existing collaborators

If you have a repository which already has collaborators, there is a utility script which will create the required terraform file and import the existing collaborators into the terraform state:

```
bin/import-repository-collaborators.rb
```

See the usage details below.

> This has already been done for all repository collaborators which existed as at 2020-11-24

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
