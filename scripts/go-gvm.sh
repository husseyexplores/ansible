#!/usr/bin/env bash

set -e

RELEASE="1.8.0" # https://github.com/voidint/g/releases/
INSTALL_DIR="${HOME}/.g"
SKIP_SHELL="false"
# Parse Flags
parse_args() {
  while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
    -d | --install-dir)
      INSTALL_DIR="$2"
      shift # past argument
      shift # past value
      ;;
    -s | --skip-shell)
      SKIP_SHELL="true"
      shift # past argument
      ;;
    -r | --release)
      RELEASE="$2"
      shift # past release argument
      shift # past release value
      ;;
    *)
      echo "Unrecognized argument $key"
      exit 1
      ;;
    esac
  done
}

function get_arch() {
    a=$(uname -m)
    case ${a} in
    "x86_64" | "amd64")
        echo "amd64"
        ;;
    "i386" | "i486" | "i586")
        echo "386"
        ;;
    "aarch64" | "arm64")
        echo "arm64"
        ;;
    "armv6l" | "armv7l")
        echo "arm"
	;;
    "s390x")
        echo "s390x"
        ;;
    *)
        echo ${NIL}
        ;;
    esac
}

function get_os() {
    echo $(uname -s | awk '{print tolower($0)}')
}

function main() {
    local os=$(get_os)
    local arch=$(get_arch)
    local dest_file="${INSTALL_DIR}/downloads/g${RELEASE}.${os}-${arch}.tar.gz"
    local url="https://github.com/voidint/g/releases/download/v${RELEASE}/g${RELEASE}.${os}-${arch}.tar.gz"

    echo "[1/3] Downloading ${url}"
    rm -f "${dest_file}"
    if [ -x "$(command -v wget)" ]; then
      wget -q -P "${INSTALL_DIR}/downloads" "${url}"
    else
      curl -s -S -L --create-dirs -o "${dest_file}" "${url}"
    fi

    echo "[2/3] Install g to the ${INSTALL_DIR}/bin"
    mkdir -p "${INSTALL_DIR}/bin"
    tar -xz -f "${dest_file}" -C "${INSTALL_DIR}/bin"
    chmod +x "${INSTALL_DIR}/bin/g"

    echo -e "\nTo configure your current shell, run:\nsource \"${INSTALL_DIR}/env\""

    exit 0
}

function setup_shell() {
   echo "[3] Setting environment variables"
    cat >${INSTALL_DIR}/env <<-EOF
#!/bin/sh
# g shell setup
export GOROOT="${INSTALL_DIR}/go"
export PATH="${INSTALL_DIR}/bin:\${GOROOT}/bin:\${GOPATH}/bin:\$PATH"
export G_MIRROR=https://golang.google.cn/dl/
	EOF

  echo -e "\nBe sure to source \`${INSTALL_DIR}/env\` to your .bashrc/.zshrc"
  echo -e "\`source ${INSTALL_DIR}/env\`"
}

parse_args "$@"
main
if [ "$SKIP_SHELL" != "true" ]; then
  setup_shell
fi
