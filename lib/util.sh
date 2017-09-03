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
    local ver="$2"
    local repo="$3"

    local safe_repo=$(echo $repo | sed -e 's,/,_,g')

    local prefix="${safe_repo}.XXX"

    local dir=$(mktemp -d -t $prefix)
    (
        cd ${dir}
        git clone -q ${uri} .
        if [ -n "${ver}" ]; then
            git checkout -q ${ver}
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

    mkdir -p ${clone_dir}/${dir}
    cp ${original} ${clone_dir}/${dir}/${file}
    (
	cd ${clone_dir}
	git add ${dir}/${file}
	git commit -m "${msg}"
	git push
    ) > /dev/null
    rm -rf ${clone_dir}
}
