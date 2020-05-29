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