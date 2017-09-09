p6_github_thing_parse() {
    local thing="$1"

    if [[ ${thing} = /* ]]; then
	GH_REPO=
	GH=
	GH_VER=
    else
	local org_proj=${thing%%%*}
	GH_REPO=${org_proj}
	GH="${GITHUB_URL}${org_proj}"
	if [[ ${thing} = *%* ]]; then
	    GH_VER=${thing##*%}
	else
	    GH_VER=master
	fi
    fi
}

p6_github_repo_clone() {
    local uri="$1"
    local repo="$2"
    local ver="$3"

    local safe_repo=$(echo $repo | sed -e 's,/,_,g')

    local prefix="${safe_repo}.XXX"

    local dir=$(mktemp -d -t $prefix)
    (
	p6_dir_cd "$dir"
	p6_git_clone "-q" "$uri" "."
	if [ -n "${ver}" ]; then
	    p6_git_checkout "-q" "$ver"
	fi
    )

    echo ${dir}
}

p6_github_repo_file_commit() {
    [ -z "${TEST_MODE}" ] || return

    local repo="$1"
    local original="$2"
    local dir="$3"
    local file="$4"
    local msg="$5"

    p6_github_thing_parse "${repo}"
    local clone_dir=$(git_repo_clone "${GH}" "" "${repo}")

    p6_mkdir "$clone_dir/$dir"
    p6_file_copy "$original" "$clone_dir/$dir/$file"
    (
	p6_git_cd "$dir"
	p6_git_add "$dir/$file"
	p6_git_commit "-m" "$msg"
	p6_git_push "-u"
    ) > /dev/null
    p6_dir_rmrf "$clone_dir"
}
