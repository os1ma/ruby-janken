#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

readonly SCRIPT_DIR="$(cd "$(dirname "$0")"; pwd)"
readonly PROJECT_HOME="${SCRIPT_DIR}/.."

readonly HEROKU_APP_NAME='ruby-janken'

cd "${PROJECT_HOME}"

heroku git:remote -a "${HEROKU_APP_NAME}"
git push heroku main
