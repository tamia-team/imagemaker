#!/bin/bash

download() {
  LOCAL_PATH=$1
  REMOTE_URL=$2
  [[ -z "${LOCAL_PATH}" ]] && echo "Undefined variable: LOCAL_PATH" > 2 && exit 129
  [[ -z "${REMOTE_URL}" ]] && echo "Undefined variable: REMOTE_URL" > 2 && exit 130
  if [[ ! -f "${LOCAL_PATH}" ]]; then
    echo "Missing script: ${LOCAL_PATH}" \
      && echo "Download it" \
      && "${CMD_WGET}" -O "${LOCAL_PATH}" "${REMOTE_URL}"
  fi
  source "${LOCAL_PATH}"
}


