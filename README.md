[![repo standards badge](https://img.shields.io/badge/dynamic/json?color=blue&style=for-the-badge&logo=github&label=MoJ%20Compliant&query=%24.result&url=https%3A%2F%2Foperations-engineering-reports.cloud-platform.service.justice.gov.uk%2Fapi%2Fv1%2Fcompliant_public_repositories%2Fgithub-collaborators)](https://operations-engineering-reports.cloud-platform.service.justice.gov.uk/public-github-repositories.html#github-collaborators "Link to report")

# GitHub Outside Collaborators

Manage MoJ GitHub Organisation outside collaborators via code.

## Requesting collaborator access

> PRs from forks do NOT work with the current automated process, please only create PRs from a branch.

If you want to allow access to an MoJ GitHub repository for an outside collaborator, please raise a pull request making the required changes to the corresponding `terraform/[repository-name].tf` file in this repository.

If you are not confident editing Terraform code, you can [raise an issue](https://github.com/ministryofjustice/github-collaborators/issues/new?labels=Access+Request&template=access-request.md) to request access for a collaborator, and we will make the changes for you.

## Background

Sometimes we need to grant access to one of more of our GitHub repositories to people who are not part of the "ministryofjustice" GitHub organisation. This often happens when we engage third-party suppliers to carry out work on our behalf.

Github allows users called outside collaborators who are not part of the organisation access to an organisations repositories. We can grant a certain level of access to a specific repository to an individual GitHub user account.

Rather than manage this via "clickops" this repository enables us to manage these relationships via Terraform code. This also means we can attach metadata to the collaborator relationship, to explain its purpose. This will help to ensure that collaborators are removed when they no longer need access to the relevant GitHub repositories.

## How it works

- The `terraform/` directory contains a file per repository that has collaborators, defining the collaboration with metadata. The name of the file is the repository name with any `.` characters replaced with `-` to render the name acceptable for Terraform. i.e. the file for repository `foo.bar` will be `terraform/foo-bar.tf`
- Github actions run `terraform plan` and `terraform apply` to keep the collaborations in GitHub in sync with the Terraform source code
- The `terraform plan` and `terraform apply` use the Terraform module [github_repository_collaborator](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_collaborator) to add Outside Collaborators, who are defined in the Terraform source code, to the MoJ Github Organisation repositories.
- Ruby code in the `bin/` and `lib/` directories (with unit tests in the `spec/` directory) queries GitHub via the REST API and GraphQL API to retrieve all the collaborator relationships which exist.
- A GitHub action runs daily that compares the collaborators in GitHub with the Terraform source code. Any collaborators which are not fully specified in the Terraform source code are removed from found repositories.

## Removing collaborators

1. If the collaborator is defined in Terraform code

- Raise and merge a PR removing the collaborator from the list of collaborators in the Terraform source code file for the repository.

2. If the collaborator is not defined in Terraform code

- This will be the case if access was granted by a repository administrator via the GitHub UI. The automation will automatically remove that user from the repository and raise an issue on that repository.

> You should not need to do this manually - there is a GitHub action which runs daily, and removes all the collaborators who are not defined in Terraform code.

To remove a specific collaborator from a repository, run this [GitHub Action](https://github.com/ministryofjustice/github-collaborators/actions/workflows/remove-collaborator.yml)

![GitHub Action UI image](doc/images/github-action.png)

1. Click the `Run workflow` button
2. Enter the repository name and the username of the collaborator to remove
3. Click `Run workflow`

## Defining collaborators

To define collaborators on a repository, first add a Terraform file corresponding to the repository name (unless there already is one).

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

To add collaborators to the repository, define each of them inside a `collaborators` block, with the following information inside the quotation marks:

```
    {
      github_user  = "<github username>"
      permission   = "push"  #  pull|push|admin
      name         = ""  #  The name of the person behind github_user
      email        = ""  #  Their email address
      org          = ""  #  The organisation/entity they belong to
      reason       = ""  #  Why is this person being granted access?
      added_by     = ""  #  Who made the decision to grant them access? e.g. 'Awesome Team <awesome.team@digital.justice.gov.uk>'
      review_after = ""  #  Date after which this grant should be reviewed/revoked, e.g. 2021-11-26
    },
```

An example, please do not add the comments to the file:

```
  collaborators = [
    {
      github_user  = "someuser"
      permission   = "admin"
      name         = "Real Name"
      email        = "name@acme.com"
      org          = "Acme. Corp."
      reason       = "Acme are building some stuff for us"
      added_by     = "Team Name <team-name@digital.justice.gov.uk>"
      review_after = "2021-11-26"
    },
  ]
```

The `added_by` line should contain an approvers email address that uses @digital.justice.gov.uk or @justice.gov.uk

You can add comments (prefixed with `#` on every line) to these files to provide additional context/information.

## Pre-requisites

To run Terraform apply locally:

- Terraform 0.13+

### Environment Variables

To run Terraform apply locally:

- `ADMIN_GITHUB_TOKEN` must contain a GitHub personal access token (PAC) enabled for MoJ SSO, with the following scopes:

  - admin:org
  - repo
  - read:user
  - user:email

- `TERRAFORM` must define the Terraform executable (e.g. `/usr/local/bin/terraform0.13.5`)

- `AWS_ACCESS_KEY_ID` & `AWS_SECRET_ACCESS_KEY` - credentials with access to the S3 bucket holding the Terraform state file

See [env.example](./env.example) for more more information.

## Usage

### [bin/outside-collaborators.rb](.github/workflows/outside-collaborators-check.yaml)

This script is run on daily basis by the [GitHub action](https://github.com/ministryofjustice/github-collaborators/actions/workflows/outside-collaborators-check.yaml). You can also run it manually by triggering the action. To run it locally:

```
ruby bin/outside-collaborators.rb
```

The script checks collaborators in Terraform against collaborators in GitHub repositories. Unknown collaborators are removed from those repositories. Issues will be raised on repositories when collaborator expiry date is up for renewal or expired. Slack alerts and repository pull requests are automatically generated when a collaborator expiry is up for renewal and has expired. It will output all outside collaborators who are defined in the Terraform code compared to the collaborators on GitHub per repository and state which collaborators are missing. It will delete expired collaborator invites to a repository which has not been accepted within the allowed time.

### bin/list-repositories.rb

Output the names of all current (i.e. excluding deleted/archived/locked) MoJ GitHub repositories.

## Development

Make sure you have `bundler` installed (`gem install bundler` if not). Run `bundle install` to set up locally.

Run the tests with `bundle exec rspec` or `rspec`. This will generate a coverage report using simplecov. You can see it by running `open coverage/index.html`

Install rspec locally and ruby-debug-ide:

```
gem install rspec --install-dir ./bin
sudo gem install ruby-debug-ide
```

To debug in VS Code use the below launch configrations within `.vscode/launch.json`:

```
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Python",
      "type": "python",
      "python": "${workspaceFolder}/venv/bin/python3",
      "request": "launch",
      "cwd": "${workspaceRoot}",
      "program": "${workspaceFolder}/scripts/check-collaborators-username.py",
      "console": "integratedTerminal",
      "args": [""]
    },
    {
      "name": "Ruby - File",
      "type": "Ruby",
      "request": "launch",
      "program": "${workspaceRoot}/bin/close-issues.rb",
      "env": {
        "ADMIN_GITHUB_TOKEN": "add-token",
        "REALLY_POST_TO_SLACK": "0",
        "REALLY_POST_TO_GH": "0",
        "OPS_BOT_TOKEN": "0",
        "LOG_LEVEL": "debug",
        "SLACK_WEBHOOK_URL": "add-slack-link",
      }
    },
    {
      "name": "RSpec - file",
      "type": "Ruby",
      "request": "launch",
      "program": "${workspaceRoot}/bin/bin/rspec",
      "args": ["${file}"]
    },
    {
      "name": "RSpec - all",
      "type": "Ruby",
      "request": "launch",
      "program": "${workspaceRoot}/bin/bin/rspec",
      "args": ["-I", "${workspaceRoot}"]
    }
  ]
}

```
