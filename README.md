# GitHub External Collaborators

Manage MoJ GitHub external collaborators via code.

## Pre-requisites

The environment variable `ADMIN_GITHUB_TOKEN` must contain a GitHub personal access
token (PAC) enabled for MoJ SSO, with the following scopes:
  * admin:org
  * repo
  * read:user
  * user:email

The environment variable `OPERATIONS_ENGINEERING_REPORTS_API_KEY` must contain the API key required to POST data to the [Operations Engineering Reports] web application.

The environment variable `OPS_ENG_REPORTS_URL` must contain the URL of the [Operations Engineering Reports] web application endpoint to which the generated JSON data should be POSTed.

## Usage

```
bin/external-collaborators.rb
```

This outputs a JSON document suitable for POSTing to the [Operations Engineering Reports] web application.

[Operations Engineering Reports]: https://github.com/ministryofjustice/operations-engineering-reports
