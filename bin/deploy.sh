#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

readonly SCRIPT_DIR="$(cd "$(dirname "$0")"; pwd)"
readonly PROJECT_HOME="${SCRIPT_DIR}/.."

readonly HEROKU_APP_NAME='ruby-janken'

cd "${PROJECT_HOME}"

set +o xtrace
echo 'start git remote add heoku...'
git remote add heroku "https://heroku:${HEROKU_API_KEY}@git.heroku.com/${HEROKU_APPNAME}.git"
echo 'end git remote add heroku...'
set -o xtrace

git push heroku main
