set -e

function setup_flutter() {
  if [[ ! -d "$HOME/flutter" ]]; then
    mkdir -p $HOME/flutter
    curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.22.2-stable.tar.xz | tar xJ -C $HOME/flutter --strip-components=1
  fi
  export PATH="$HOME/flutter/bin:$PATH"
}
