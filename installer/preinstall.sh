#!/bin/bash
# +----------------+
# | npm preinstall |
# +----------------+

# get the installer directory
Installer_get_current_dir () {
  SOURCE="${BASH_SOURCE[0]}"
  while [ -h "$SOURCE" ]; do
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
  done
  echo "$( cd -P "$( dirname "$SOURCE" )" && pwd )"
}

Installer_dir="$(Installer_get_current_dir)"

# move to installler directory
cd "$Installer_dir"

source utils.sh

# module name
Installer_module="MMM-NewsFeed"
Version="$(node -p -e "require('./../package.json').version")"
Installer_info "Welcome to $Installer_module v$Version"

# delete package-lock.json (force)
rm -f ../package-lock.json

# Check not run as root
if [ "$EUID" -eq 0 ]; then
  Installer_error "npm install must not be used as root"
  exit 1
fi

echo

# switch branch
Installer_info "Installing Sources..."
git checkout -f master 2>/dev/null || Installer_error "Installing Error !"
git pull 2>/dev/null

echo
Installer_info "Installing all npm libraries..."
