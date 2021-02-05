#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

readonly SCRIPT_DIR="$(cd "$(dirname "$0")"; pwd)"
readonly PROJECT_HOME="${SCRIPT_DIR}/.."

cd "${PROJECT_HOME}"

# スタイルチェック
bundle exec rubocop

# RSpec のテスト
bundle exec rspec

# ruby コマンドでの実行のテスト
echo -e "0\n0" | ruby ./lib/janken_cli.rb

# 依存関係の脆弱性診断
bundle exec bundle-audit check --update
