#!/bin/bash
echo "{\"app_name\": \"${APP_NAME}\", \"command\": \"run\", \"script\": \"${APP_POETRY_SCRIPT}\", \"module\": \"${APP_MODULE}\"}"
  [ -z "${APP_MODULE}" ] && echo "Environment variable is missing: $(APP_MODULE)" && exit 128
  exec poetry run ${APP_POETRY_SCRIPT} run --module ${APP_MODULE}
