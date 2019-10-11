#!/bin/bash

check_brew() {
  echo checking brew
  brew update
  brew outdated --quiet | wc -l | tr -d '[:space:]' > /tmp/.brew-outdated
}

check_npm() {
  echo checking npm
  npm outdated --global --parseable | grep -v "linked$" | grep -v "npm" | wc -l | tr -d '[:space:]' > /tmp/.npm-outdated
}

check_pip() {
  echo checking pip2
  pip2 list --outdated --format=freeze | wc -l | tr -d '[:space:]' > /tmp/.pip2-outdated
  echo checking pip3
  pip3 list --outdated --format=freeze | wc -l | tr -d '[:space:]' > /tmp/.pip3-outdated
}

check_ckan() {
#  echo "Skipping CKAN until I update everything to KSP 1.4"
#  echo "0" > /tmp/.ckan-outdated
  echo checking ckan
  ckan update
  ckan list | grep "^\\^" | wc -l | tr -d '[:space:]' > /tmp/.ckan-outdated
}

check_brew
check_npm
check_pip
check_ckan

