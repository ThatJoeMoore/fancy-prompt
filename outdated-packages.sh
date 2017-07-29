#!/bin/bash

check_brew() {
  echo checking brew
  brew update
  brew outdated --quiet | wc -l | tr -d '[:space:]' > /tmp/.brew-outdated
}

check_npm() {
  echo checking npm
  npm outdated --global | wc -l | tr -d '[:space:]' > /tmp/.npm-outdated
}

check_pip() {
  echo checking pip2
  pip2 list --outdated --format=legacy | wc -l | tr -d '[:space:]' > /tmp/.pip2-outdated
  echo checking pip3
  pip3 list --outdated --format=legacy | wc -l | tr -d '[:space:]' > /tmp/.pip3-outdated
}

check_brew
check_npm
check_pip

