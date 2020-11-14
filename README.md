### init.zsh:
- p6df::modules::p6github::deps()
- p6df::modules::p6github::external::brew()
- p6df::modules::p6github::init()

### api.sh:
- p6_github_api_org_repos_clone(org, dir, [parallel=8])
- p6_github_api_org_repos_list(org)
- p6_github_api_repo_clone_or_pull(ou, dir, repo)
- p6_github_api_user_repos_clone(user, dir, [parallel=8])
- p6_github_api_user_repos_list(user)

### cli.sh:
- code rc = p6_github_gh_cmd(cmd, ...)
- p6_github_cli_branch(branch, msg)
- p6_github_cli_submit(msg)
- p6_github_gh_pr_checkout(pr, ...)
- p6_github_gh_pr_list()
- p6_github_gh_pr_view(pr, ...)

### oauth.sh:
- p6_github_oauth_token_clear()
- p6_github_oauth_token_del(gh_api, user, pass, id)
- p6_github_oauth_token_get(gh_api, user, pass, note)

### util.sh:
- p6_github_thing_clear()
- p6_github_thing_parse(thing)

