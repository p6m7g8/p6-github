p6_github_gh_cmd() {
    local cmd="$1"
    shift 1

    local log_type
    case $cmd in
	*) log_type=p6_run_write_cmd ;;
    esac

    p6_run_code "$log_type gh $cmd $@"
    local rc=$?

    p6_return_code_as_code "$rc";
}

######################################################################
#<
#
# Function: p6_github_cli_submit(msg)
#
#  Args:
#	msg -
#
#>
######################################################################
p6_github_cli_submit() {
  local msg="$1"

  local token=$(p6_token_random "4")
  local myb="branch-$token"

  (
    git checkout -b $myb
    git add .
    git commit -m "$msg"
    gh pr create -a pgollucci -f
    git checkout master
    git branch -D $myb
  )

  p6_return_void
}

p6_github_gh_pr_list() {

    p6_github_gh_cmd pr list
}
