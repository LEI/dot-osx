#!/bin/sh

# Usage: ./brew-unbundle.sh [file]
# Remove formulas from a Brewfile, the opposite of `brew bundle`

# Similar script:
# https://github.com/mas-cli/mas/issues/81#issuecomment-289570481

set -e

if ! hash trash 2>/dev/null; then
  echo >&2 "Install trash with 'brew install trash' before running this script."
  exit 1
fi

file="${1:-Brewfile}"

# if [ ! -f "$file" ]; then
#   echo >&2 "$0: $file: No such file"
#   exit 1
# fi

while read -r line; do
  case "$line" in
    # Ignore comment lines /^#/
    \#*) continue ;;
    # Ignore lines matching /# KEEP$/
    # to avoid uninstalling essential packages
    *\#\ KEEP) continue ;;
    # Strip end of line comments / # *$/
    *\ \#\ *) line="${line% # *}" ;;
    # Ignore empty lines
    "") continue ;;
  esac
  # Remove everything after the first comma
  line="${line%%,*}"
  # Strip trailing spaces # awk '{$1=$1;print}'
  line="${line%[[:blank:]]}"
  # Retrieve first word and remove it
  word=$(echo "$line" | cut -d" " -f 1)
  name="${line#$word }"
  case "$word" in
    # "") echo >&2 "$file: empty line"; exit 1 ;;
    brew) cmd="$word uninstall $name" ;;
    cask) cmd="brew $word uninstall $name" ;;
    tap) cmd="brew untap $name" ;;
    # TODO: handle custom appdir
    mas) cmd="trash /Applications/$name.app" ;;
    *) continue ;;
  esac
  # Print the command in verbose mode
  if [ "$DOT_VERBOSE" = 1 ]; then
    echo "$cmd"
  fi
  # Execute the command, allowing quoted arguments
  eval "$cmd"
done <"$file"
