# GitHub External Collaborators

Manage MoJ GitHub external collaborators via code.

## Pre-requisites

The environment variable `GITHUB_TOKEN` must contain a GitHub personal access
token (PAC) enabled for MoJ SSO, with the following scopes:
  * admin:org
  * repo
  * read:user
  * user:email

## Usage

```
bin/external-collaborators.rb
```

This outputs a JSON document suitable for POSTing to the [Operations Engineering Reports] web application.

[Operations Engineering Reports]: https://github.com/ministryofjustice/operations-engineering-reports
