### api.sh:
- p6_github_api_org_repos_clone(gh, gh_api, org, dir, auth, [parallel=8])
- p6_github_api_org_repos_list(gh_api, org, auth)
- p6_github_api_orgs_list(gh_api, pass, auth)
- p6_github_api_paginate(url, auth)
- p6_github_api_repo_clone_or_pull(gh, org, dir, repo)
- p6_github_api_user_repos_clone(gh, gh_api, user, dir, auth, [parallel=8])
- p6_github_api_user_repos_list(gh_api, user, auth)

### cli.sh:
- p6_github_cli_submit(msg)

### oauth.sh:
- p6_github_oauth_token_clear()
- p6_github_oauth_token_del(gh_api, user, pass, id)
- p6_github_oauth_token_get(gh_api, user, pass, note)

### util.sh:
- p6_github_repo_clone(uri, repo, ver)
- p6_github_repo_file_commit(repo, original, dir, file, msg)
- p6_github_thing_clear()
- p6_github_thing_parse(thing)

