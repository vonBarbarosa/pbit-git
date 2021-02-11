#!/bin/bash

DIR=$(pwd);
cd .git/hooks

echo "=== Starting git hooks installation ======="

# Create link for every git hook in the folder
echo '  Installing git hooks in' $(pwd)
for i in $(ls $DIR/git/hooks/); do
  new_link_file=$DIR/git/hooks/$i
  # Overwrite any existing git hooks with the same name
  ln -sf $DIR/git/hooks/$i . && echo "  $i link created"
done

echo "=== Git hooks installation finish ========="

echo "=== Checking if commands are installed ===="

command_exists () {
  type "$1" &> /dev/null ;
}

all_commands_installed=true
install_command="  sudo apt install "

if ! (command_exists unzip && command_exists zip) ; then
  install_command+="zip unzip "
  $all_commands_installed=false
fi

if ! command_exists jq ; then
  install_command+="jq "
  $all_commands_installed=false
fi

if ! command_exists xmllint ; then
  install_command+="libxml2-utils "
  all_commands_installed=false
fi

if ! $all_commands_installed ; then
  echo "  ERROR: Please install missing commands:"
  echo $install_command
  echo
  exit 1
fi

echo "=== Commands installed, everything's ok ==="

echo "=== Running post-commit to unpack reports ="

cd - &> /dev/null
./.git/hooks/post-commit