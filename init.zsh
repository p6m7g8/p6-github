p6df::modules::p6github::version() { echo "0.0.1" }
p6df::modules::p6github::deps()    { }
p6df::modules::p6github::external::brew() { }

p6df::modules::p6github::init() {

  local dir="$P6_DFZ_SRC_DIR/p6m7g8/p6github"
  p6_bootstrap "$dir"
}
