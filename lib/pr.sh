######################################################################
#<
#
# Function: p6_github_gh_pr_submit(msg)
#
#  Args:
#	msg -
#
#>
######################################################################
p6_github_gh_pr_submit() {
    local msg="$1"

    local token
    token=$(p6_token_random "4")
    local myb="branch-$token"

    p6_git_p6_branch_create "$myb"
    if p6_string_blank "$msg"; then
        git commit -v
    else
        p6_git_p6_commit "$msg"
    fi
    p6_github_gh_pr_create "$USER"
    p6_git_p6_checkout "master" #XXX: main
    p6_git_p6_branch "-D" "$myb"

    p6_return_void
}