# p6github

## Table of Contents


### p6github
- [p6github](#p6github)
  - [Badges](#badges)
  - [Distributions](#distributions)
  - [Summary](#summary)
  - [Contributing](#contributing)
  - [Code of Conduct](#code-of-conduct)
  - [Changes](#changes)
    - [Usage](#usage)
  - [Author](#author)

### Badges

[![License](https://img.shields.io/badge/License-Apache%202.0-yellowgreen.svg)](https://opensource.org/licenses/Apache-2.0)
[![Gitpod ready-to-code](https://img.shields.io/badge/Gitpod-ready--to--code-blue?logo=gitpod)](https://gitpod.io/#https://github.com/p6m7g8/p6github)
[![Mergify](https://img.shields.io/endpoint.svg?url=https://gh.mergify.io/badges/p6m7g8/p6github/&style=flat)](https://mergify.io)
[![codecov](https://codecov.io/gh/p6m7g8/p6github/branch/master/graph/badge.svg?token=14Yj1fZbew)](https://codecov.io/gh/p6m7g8/p6github)
[![Known Vulnerabilities](https://snyk.io/test/github/p6m7g8/p6github/badge.svg?targetFile=package.json)](https://snyk.io/test/github/p6m7g8/p6github?targetFile=package.json)

## Summary

## Contributing

- [How to Contribute](CONTRIBUTING.md)

## Code of Conduct

- [Code of Conduct](CODE_OF_CONDUCT.md)

## Changes

- [Change Log](CHANGELOG.md)

### Usage

#### init.zsh:

- p6df::modules::p6github::deps()
- p6df::modules::p6github::external::brew()
- p6df::modules::p6github::init()

#### api.sh:

- p6_github_api_org_repos_clone(org, dir, [parallel=8])
- p6_github_api_org_repos_list(org)
- p6_github_api_repo_clone_or_pull(ou, dir, repo)
- p6_github_api_user_repos_clone(user, dir, [parallel=8])
- p6_github_api_user_repos_list(user)

#### cli.sh:

- code rc = p6_github_gh_cmd(cmd, ...)
- p6_github_cli_branch(branch, msg)
- p6_github_cli_submit(msg)
- p6_github_gh_action_log(action_id)
- p6_github_gh_action_view()
- p6_github_gh_actions_list()
- p6_github_gh_pr_checkout(pr, ...)
- p6_github_gh_pr_comment(pr, ...)
- p6_github_gh_pr_list()
- p6_github_gh_pr_merge(pr, ...)
- p6_github_gh_pr_view(pr, ...)
- str action_id = p6_github_gh_actions_last()

#### oauth.sh:

- p6_github_oauth_token_clear()
- p6_github_oauth_token_del(gh_api, user, pass, id)
- p6_github_oauth_token_get(gh_api, user, pass, note)

#### util.sh:

- p6_github_thing_clear()
- p6_github_thing_parse(thing)


## Author

Philip M . Gollucci <pgollucci@p6m7g8.com>
