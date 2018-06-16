p6df::modules::p6github::version() { echo "0.0.1" }
p6df::modules::p6github::deps()    { }
p6df::modules::p6github::external::brew() { }

p6df::modules::p6github::init() {

  p6_github_init $P6_DFZ_SRC_DIR/p6m7g8/p6github
}

p6_github_init() {
  local dir="$1"

  local file
  for file in $dir/lib/*.sh; do
    p6_file_load "$file"
  done
}

p6df::modules::p6github::init
