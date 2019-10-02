######################################################################
#<
#
# Function:
#	p6_github_api_paginate(url, auth)
#
#  Args:
#	url - 
#	auth - 
#
#>
######################################################################
p6_github_api_paginate() {
    local url="$1"
    local auth="$2"

    local dir=$(mktemp -d -t gh.pagination)
    local file=${dir}/output.txt

    rm -f $file

    curl -i -s $(echo $auth) "$url" >> $file

    local next_url
    local prev=-1
    local num=0
    while [ : ]; do
	next_url="$(grep ^Link $file | tail -1 | awk '{ print $2 }'  |sed -e 's,[><;],,g')"
	prev=$num
	num=$(echo $next_url | sed -e 's,.*\=,,')
	[ -z "$num" ] && num=-2

	if [ $prev -gt $num ]; then
	    break
	fi
        
	curl -i -s $(echo $auth) $next_url >> $file
    done

    cat $file
    rm -f $file
}

######################################################################
#<
#
# Function:
#	p6_github_api_orgs_list(gh_api, pass, auth)
#
#  Args:
#	gh_api - 
#	pass - 
#	auth - 
#
#>
######################################################################
p6_github_api_orgs_list() {
    local gh_api="$1"
    local pass="$2"
    local auth="$3"

    p6_github_api_paginate "${gh_api}/organizations" "$auth" | awk '/login/{ print $2 }' | sed -e 's/[",]//g' | sort
}

######################################################################
#<
#
# Function:
#	p6_github_api_org_repos_list(gh_api, org, auth)
#
#  Args:
#	gh_api - 
#	org - 
#	auth - 
#
#>
######################################################################
p6_github_api_org_repos_list() {
    local gh_api="$1"
    local org="$2"
    local auth="$3"

    local repos="$(p6_github_api_paginate "${gh_api}/orgs/${org}/repos" "$auth")"
    echo $repos | _p6_github_repos_extract "$org"
}

######################################################################
#<
#
# Function:
#	p6_github_api_user_repos_list(gh_api, user, auth)
#
#  Args:
#	gh_api - 
#	user - 
#	auth - 
#
#>
######################################################################
p6_github_api_user_repos_list() {
    local gh_api="$1"
    local user="$2"
    local auth="$3"

    local repos=$(p6_github_api_paginate "${gh_api}/users/${user}/repos?type=owner" "$auth")
    echo $repos | _p6_github_repos_extract "$user"
}

######################################################################
#<
#
# Function:
#	p6_github_api_org_repos_clone(gh, gh_api, org, dir, auth, [parallel=8])
#
#  Args:
#	gh - 
#	gh_api - 
#	org - 
#	dir - 
#	auth - 
#	OPTIONAL parallel -  [8]
#
#>
######################################################################
p6_github_api_org_repos_clone() {
    local gh="$1"
    local gh_api="$2"
    local org="$3"
    local dir="$4"
    local auth="$5"
    local parallel="${6:-8}"

    local repos=$(p6_github_api_org_repos_list "$gh_api" "$org" "$auth")
    p6_run_parallel "0" "$parallel" "$repos" "p6_github_api_repo_clone_or_pull" "$gh" "$org" "$dir"
}

######################################################################
#<
#
# Function:
#	p6_github_api_user_repos_clone(gh, gh_api, user, dir, auth, [parallel=8])
#
#  Args:
#	gh - 
#	gh_api - 
#	user - 
#	dir - 
#	auth - 
#	OPTIONAL parallel -  [8]
#
#>
######################################################################
p6_github_api_user_repos_clone() {
    local gh="$1"
    local gh_api="$2"
    local user="$3"
    local dir="$4"
    local auth="$5"
    local parallel="${6:-8}"

    local repos=$(p6_github_api_user_repos_list  "$gh_api" "$user" "$auth")

    p6_run_parallel "0" "8" "$repos" "p6_github_api_repo_clone_or_pull" "$gh" "$user" "$dir"
}

######################################################################
#<
#
# Function:
#	p6_github_api_repo_clone_or_pull(gh, org, dir, repo)
#
#  Args:
#	gh - 
#	org - 
#	dir - 
#	repo - 
#
#>
######################################################################
p6_github_api_repo_clone_or_pull() {
    local gh="$1"
    local org="$2"
    local dir="$3"
    local repo="$4"

    [ -d $dir/$org/$repo ] && return

    if [ -d $dir/$org/$repo ]; then
	echo "=====> $repo [pull]"
	(cd $dir/$org/$repo ; git pull -q)
    else
	echo "=====> $repo [clone]"
	mkdir -p $dir/$org/$repo
	(cd $dir/$org ; git clone -q --depth 1 ${gh}/${org}/${repo}.git > /dev/null)
    fi
}