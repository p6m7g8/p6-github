# shellcheck shell=bash
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

  p6_github_gh_cmd pr review "$pr" --comment -b "$@"
}

######################################################################
#<
#
# Function: p6_github_gh_pr_merge(pr, ...)
#
#  Args:
#	pr -
#	... - 
#
#>
######################################################################
p6_github_gh_pr_merge() {
  local pr="$1"
  shift 1

  p6_github_gh_cmd pr merge -d -s "$pr"
}

######################################################################
#<
#
# Function: p6_github_gh_actions_list()
#
#>
######################################################################
p6_github_gh_actions_list() {

  p6_github_gh_cmd api /repos/:owner/:repo/actions/runs | jq -M -r ".workflow_runs[] | .id"
}

######################################################################
#<
#
# Function: str action_id = p6_github_gh_actions_last()
#
#  Returns:
#	str - action_id
#
#>
######################################################################
p6_github_gh_actions_last() {

  local action_id
  action_id=$(p6_github_gh_actions_list | head -1)

  p6_return_str "$action_id"
}

######################################################################
#<
#
# Function: p6_github_gh_action_log(action_id)
#
#  Args:
#	action_id -
#
#>
######################################################################
p6_github_gh_action_log() {
  local action_id="$1"

  p6_github_gh_cmd api /repos/:owner/:repo/actions/runs/"$action_id"/logs
}

######################################################################
#<
#
# Function: p6_github_gh_action_view()
#
#>
######################################################################
p6_github_gh_action_view() {

  local action_id
  action_id=$(p6_github_gh_actions_last)

  local dir=
  dir=$(p6_transient_create "p6_ghav")
  local zip=
  zip="$dir/logs.zip"

  p6_github_gh_action_log "$action_id" >"$zip"

  (
    cd "$dir" || true
    unzip "$zip"
    p6_file_rmf "$zip"

    local file
    for file in **/*; do
      p6_color_say "blue" "white" "----------------------------------------------"
      p6_color_say "blue" "white" "$file"
      p6_color_say "blue" "white" "----------------------------------------------"
      p6_file_display "$file"
      p6_msg
    done
  )

  p6_transient_delete "$dir"
}

######################################################################
#<
#
# Function: str json = p6_github_gh_action_status_json(action_id)
#
#  Args:
#	action_id -
#
#  Returns:
#	str - json
#
#>
######################################################################
p6_github_gh_action_status_json() {
  local action_id="$1"

  local json
  json=$(p6_github_gh_cmd api /repos/:owner/:repo/actions/runs/"$action_id" |
    jq -M -r "{name: .name, event: .event, status: .status, conclusion: .conclusion}")

  p6_return_str "$json"
}

######################################################################
#<
#
# Function: p6_github_gh_action_status()
#
#>
######################################################################
p6_github_gh_action_status() {

  local action_id
  action_id=$(p6_github_gh_actions_last)

  p6_github_gh_action_status_json "$action_id"
}