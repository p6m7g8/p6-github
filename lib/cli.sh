# shellcheck shell=sh
######################################################################
#<
#
# Function: code rc = p6_github_gh_cmd(cmd, ...)
#
#  Args:
#	cmd -
#	... - 
#
#  Returns:
#	code - rc
#
#>
######################################################################
p6_github_gh_cmd() {
  local cmd="$1"
  shift 1

  local log_type
  case $cmd in
  *) log_type=p6_run_write_cmd ;;
  esac

  p6_run_code "$log_type gh $cmd $*"
  local rc=$?

  p6_return_code_as_code "$rc"
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

  local token
  token=$(p6_token_random "4")
  local myb="branch-$token"

  (
    git checkout -b "$myb"
    if p6_string_blank "$msg"; then
      git commit -v
    else
      git commit -m "$msg"
    fi
    gh pr create -a pgollucci -f
    git checkout master
    git branch -D "$myb"
  )

  p6_return_void
}

######################################################################
#<
#
# Function: p6_github_cli_branch(branch, msg)
#
#  Args:
#	branch -
#	msg -
#
#>
######################################################################
p6_github_cli_branch() {
  local branch="$1"
  local msg="$2"

  (
    git checkout -b "$branch"
    if p6_string_blank "$msg"; then
      git commit -v
    else
      git commit -m "$msg"
    fi
    git push -u
  )

  p6_return_void
}

######################################################################
#<
#
# Function: p6_github_gh_pr_list()
#
#>
######################################################################
p6_github_gh_pr_list() {

  p6_github_gh_cmd pr list
}

######################################################################
#<
#
# Function: p6_github_gh_pr_checkout(pr, ...)
#
#  Args:
#	pr -
#	... - 
#
#>
######################################################################
p6_github_gh_pr_checkout() {
  local pr="$1"
  shift 1

  p6_github_gh_cmd pr checkout "$pr" "$@"
}

######################################################################
#<
#
# Function: p6_github_gh_pr_view(pr, ...)
#
#  Args:
#	pr -
#	... - 
#
#>
######################################################################
p6_github_gh_pr_view() {
  local pr="$1"
  shift 1

  p6_github_gh_cmd pr view -w "$pr" "$@"
}

######################################################################
#<
#
# Function: p6_github_gh_pr_comment(pr, ...)
#
#  Args:
#	pr -
#	... - 
#
#>
######################################################################
p6_github_gh_pr_comment() {
  local pr="$1"
  shift 1

  gh pr review $pr --comment -b "$@"
}