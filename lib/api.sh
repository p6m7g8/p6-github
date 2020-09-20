######################################################################
#<
#
# Function: p6_github_api_org_repos_list(org)
#
#  Args:
#	org - 
#
#>
######################################################################
p6_github_api_org_repos_list() {
    local org="$1"

    gh api orgs/"$org"/repos --paginate | jq -M -r "[.[] | .clone_url ]" | grep http | sed -e 's,.*/,,' -e 's,",,g' -e 's/,//' -e 's,\.git$,,' | sort
}

######################################################################
#<
#
# Function: p6_github_api_user_repos_list(user)
#
#  Args:
#	user - 
#
#>
######################################################################
p6_github_api_user_repos_list() {
    local user="$1"

    gh api users/"$user"/repos --paginate | jq -M -r "[.[] | .clone_url ]" | grep http | sed -e 's,.*/,,' -e 's,\.git\",,' -e 's,",,g' -e 's/,//' | sort
}

######################################################################
#<
#
# Function: p6_github_api_org_repos_clone(org, dir, [parallel=8])
#
#  Args:
#	org - 
#	dir - 
#	OPTIONAL parallel -  [8]
#
#>
######################################################################
p6_github_api_org_repos_clone() {
    local org="$1"
    local dir="$2"
    local parallel="${3:-8}"

    local repos
    repos=$(p6_github_api_org_repos_list "$org")
    p6_run_parallel "0" "$parallel" "$repos" "p6_github_api_repo_clone_or_pull" "$org" "$dir"
}

######################################################################
#<
#
# Function: p6_github_api_user_repos_clone(user, dir, [parallel=8])
#
#  Args:
#	user - 
#	dir - 
#	OPTIONAL parallel -  [8]
#
#>
######################################################################
p6_github_api_user_repos_clone() {
    local user="$1"
    local dir="$2"
    local parallel="${3:-8}"

    local repos
    repos=$(p6_github_api_user_repos_list "$user")

    p6_run_parallel "0" "8" "$repos" "p6_github_api_repo_clone_or_pull" "$user" "$dir"
}

######################################################################
#<
#
# Function: p6_github_api_repo_clone_or_pull(ou, dir, repo)
#
#  Args:
#	ou - 
#	dir - 
#	repo - 
#
#>
######################################################################
p6_github_api_repo_clone_or_pull() {
    local ou="$1"
    local dir="$2"
    local repo="$3"

    if p6_dir_exists "$dir/$ou/$repo"; then
        p6_h1 "$repo [pull]"
        (p6_dir_cd "$dir/$ou/$repo" ; p6_git_cmd pull -q)
    else
        p6_h1 "$repo [clone]"
        p6_dir_mk "$dir/$ou/$repo"
        (p6_dir_cd "$dir/$ou" ; gh repo clone "${ou}"/"${repo}"  -- -q --depth 1  > /dev/null)
    fi
}