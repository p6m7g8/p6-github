_p6_github_repos_extract() {
    local prefix="$1"

    awk '/full_name/{ print $2 }' | sed -e 's/[",]//g' -e "s,$prefix/,,g" | sort 
}