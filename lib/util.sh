######################################################################
#<
#
# Function: p6_github_thing_parse(thing)
#
#  Args:
#	thing -
#
#>
######################################################################
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

######################################################################
#<
#
# Function: p6_github_thing_clear()
#
#>
######################################################################
p6_github_thing_clear() {

    unset GH
    unset GH_REPO
    unset GH_VER
}