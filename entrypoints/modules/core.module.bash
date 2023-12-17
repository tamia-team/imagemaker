#!/bin/bash

# ## Ressources
#
# - https://stackoverflow.com/a/28776166
#


#
# Helper function
#
# Credits: https://stackoverflow.com/a/28776166
#
is_sourced() {
  if [ -n "$ZSH_VERSION" ]; then 
      case $ZSH_EVAL_CONTEXT in *:file:*) return 0;; esac
  else  # Add additional POSIX-compatible shell names here, if needed.
      case ${0##*/} in dash|-dash|bash|-bash|ksh|-ksh|sh|-sh) return 0;; esac
  fi
  return 1  # NOT sourced.
}

# Sample call.
is_sourced && sourced=1 || sourced=0
