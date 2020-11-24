# GitHub External Collaborators

Manage MoJ GitHub external collaborators via code.

## Functions

* List all external collaborators with access to Ministry of Justice github repositories, and post the data to the [Operations Engineering Reports] web application
* Define external collaborators in terraform code
* Import pre-existing external collaborators from individual github repositories, create the corresponding terraform code and import into terraform state

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

### ` bin/generate-terraform-for-repository.rb`

This script takes the name of an MoJ github repository as a single paramater, and creates a file in the `terraform` directory defining all of that repository's external collaborators.

e.g. running

```
bin/generate-terraform-for-repository.rb acronyms
```

...will create the file `terraform/acronyms.tf`

[Operations Engineering Reports]: https://github.com/ministryofjustice/operations-engineering-reports
[triggering the action]: https://github.com/ministryofjustice/operations-engineering-github-collaborators/actions?query=workflow%3A.github%2Fworkflows%2Fpost-data.yaml
[Terraform]: https://www.terraform.io/downloads.html
