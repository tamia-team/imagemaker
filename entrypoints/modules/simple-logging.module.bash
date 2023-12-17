#!/bin/bash

#
# # deepnox/docker-app-entrypoint: logging tools. 
#
# ## Ressources 
#
# - https://codereview.stackexchange.com/a/255672
# 
# ## License
#
# > An open source script provided by the [Deepnox SAS Team](https://deepnox.io)
# > Released under the [MIT license](https://opensource.org/license/MIT/)
#


#
# ## Set debug (cf. https://unix.stackexchange.com/a/521780) 
#
set -eu


# 
# ## Generic function to log.
# 
# Usage: log [-e] [-f FILE] MESSAGE...
# 
log() {
    local prefix=""
    local stream=1
    local files=()
    # handle options
    while ! ${1+false}
    do case "$1" in
        -e|--error) prefix="ERROR:"; stream=2 ;;
        -f|--file) shift; files+=("${1-}") ;;
        --) shift; break ;; # end of arguments
        -*) log -e "log: invalid option '$1'"; return 1;;
        *) break ;; # start of message
       esac
       shift
    done
    if ${1+false}
    then log -e "log: no message!"; return 1;
    fi
    # if we have a prefix, update our argument list
    if [ "$prefix" ]
    then set -- "$prefix" "$@"
    fi
    # now perform the action
    printf '%b ' "$@" '\n' | tee -a "${files[@]}" >&$stream
}
