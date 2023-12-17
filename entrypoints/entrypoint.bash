#!/bin/bash

# ## Set debug (cf. https://unix.stackexchange.com/a/521780)
if [[ "${DEBUG_FUNCTRACE}" == "1" ]]; then 
  set -x
  set -o functrace
fi

# ## Commands
CMD_CURL="$(which curl)"
CMD_WGET="$(which wget)"

#
# ## Global variables
# 

#
# ### Application: environment variables
# 

export PYTHONPATH="${PYTHONPATH}:/app/src:$(find /app -name site-packages -type d | tr '\n' ':')"
export PYTHON_BIN=$(which python3)
export APP_NAME="${APP_NAME:-default-app}"
export APP_POETRY_SCRIPT_PATH="${APP_POETRY_SCRIPT_PATH:-$APP_NAME}"
export DEFAULT_APP_POETRY_SCRIPT="/app/src/${APP_POETRY_SCRIPT_PATH}/main.py"
export APP_POETRY_SCRIPT="${APP_POETRY_SCRIPT:-$DEFAULT_APP_POETRY_SCRIPT}"
export APP_SCRIPT_START="${APP_SCRIPT_START:-/opt/start.bash}"
export HOME="/app"
export POETRY_HOME="/app/.poetry"
export PATH="${POETRY_HOME}/bin:${PATH}"
export POETRY_VIRTUALENVS_PATH="${POETRY_HOME}/venv"
export POETRY_VIRTUALENVS_CREATE="${POETRY_VIRTUALENVS_CREATE:-true}"

#
# ### Import modules
#

MODULES="core download logging"
for MODULE_NAME in $MODULES; do
  [ -f "/opt/modules/${MODULE_NAME}.module.bash" ] && echo "Loading module: ${MODULE_NAME}" && source /opt/modules/${MODULE_NAME}.module.bash || echo "Module not found: ${MODULE_NAME}" 
done

print_help() {
  echo ""
  echo "Usage: $0 COMMAND"
  echo ""
  echo "A generic entrypoint script for Docker images"
  echo ""
  echo "Commands: "
  echo "  help      Display this help"
  echo "  console   Run a bash session in the running container"
  echo "  wait      Run a container which does nothing - useful to debug"
  echo "  start     Start application or run a job"
  echo "  run       Run any command in the running container"
  echo ""
  echo "> An open source script provided by the [Deepnox SAS Team](https://deepnox.io)"
  echo "> Released under the [MIT license](https://opensource.org/license/MIT/)"
  echo ""
}

console() {
  echo "{\"app_name\": \"${APP_NAME}\", \"command\": \"console\"}" \
  && exec bash
}

wait() {
   echo "{\"app_name\": \"${APP_NAME}\", \"command\": \"wait\"}" \
   && exec sleep infinite
}

preprocess() {
  APP_SCRIPT_BEFORE_START="${APP_SCRIPT_BEFORE_START:-/opt/pre.bash}"
  if [[ -f "${APP_SCRIPT_BEFORE_START}" ]]; then
    echo "Executing \`${APP_SCRIPT_BEFORE_START}\` for starting application." \
    && exec . ${APP_SCRIPT_BEFORE_START}
  fi
}

start_app() {
  echo "{\"app_name\": \"${APP_NAME}\", \"command\": \"start\"}"
  if [[ -f "${APP_SCRIPT_START}" ]]; then
     echo "Starting application: \`${APP_SCRIPT_START}\`." \
     && exec . ${APP_SCRIPT_START}
}


preprocess  # Init

command=${1}
case ${command} in
   help)
      print_help 
      ;;
   console)
      console
      ;;
   wait)
      wait
      ;;
   start)
      preprocess
      start_app
      ;;
   run)
      echo '{"command": "$@"}' \
      && shift \
      && exec "$@"
      ;;
   *)
      print_help 
      ;;
esac

