#!/bin/bash

_count_updates() {
  local type=$1
  local f=/tmp/.$type-outdated
  local upd=0
  if [ -f "$f" ]; then
    upd=`cat $f`
  fi
  echo $upd
}

_has_updates() {
  local type=$1

  local cnt=`_count_updates $type`
  if [ "$cnt" -gt "0" ]; then
	  return 0
  fi
  return 1
}

_update_prompt() {
  local type=$1
  local icon=$2

  local upd=`_count_updates $type`
  if [ "$upd" -gt 0 ]; then
    echo -e "\x1B[104m\x1B[97m$icon You have $upd $1 update(s).$icon \x1B[0m"
  fi
}

# configure my multi-line prompt
fancyprompt() {
  local e="$?"
  prompt=⏩
  #if [ $e -ne 0 ]; then
  #  prompt=💩
  #fi

  echo 

  _update_prompt brew 🍺
  _update_prompt npm 📦
  _update_prompt pip2 🐍
  _update_prompt pip3 🐍
  _update_prompt ckan 🚀
  
  local where=$PWD
  local home=$HOME
  local work="$home/work"

  where="${where/$work/🏢 }"
  where="${where/$home/🏠 }"
  where="${where/\/keybase//🔐 }"

  PS1="$where
$prompt  "
}

__exit_status() {
	E="$?"
	PS1='$E >>'
}

PROMPT_COMMAND=fancyprompt
#PROMPT_COMMAND=__exit_status

update_all() {
  ~/bin/fancy-prompt/outdated-packages.sh
  if _has_updates brew; then
	  echo "Updating Brew"
	  brew upgrade
  fi

  if _has_updates npm; then
	  echo "Updating NPM"
	  npm update -g
  fi

  if _has_updates pip2; then
	  echo "Updating Pip2"
	  pip2 list --outdated --format=freeze | cut -d = -f 1 | xargs -n1 pip2 install -U
	  echo "Running pip update again, because that's necessary"
	  pip2 list --outdated --format=freeze | cut -d = -f 1 | xargs -n1 pip2 install -U
  fi

  if _has_updates pip3; then
	  echo "Updating Pip3"
	  pip3 list --outdated --format=freeze | cut -d = -f 1 | xargs -n1 pip3 install -U
	  echo "Running pip update again, because that's necessary"
	  pip3 list --outdated --format=freeze | cut -d = -f 1 | xargs -n1 pip3 install -U
  fi

  if _has_updates ckan; then
	  echo "Updating CKAN"
	  ckan upgrade --all
  fi

  ~/bin/fancy-prompt/outdated-packages.sh
  echo "Finished updating"
}

