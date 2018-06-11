p6df::modules::p6github::version() { echo "0.0.1" }
p6df::modules::p6github::deps()    { }
p6df::modules::p6github::external::brew() { }

p6df::modules::p6github::init() {

    local dir=$P6_DFZ_DATA_PARENT/p6m7g8/p6github

    local file
    for file in $dir/lib/*.sh; do
         p6_file_load "$file"
    done
}

p6df::modules::p6github::init
