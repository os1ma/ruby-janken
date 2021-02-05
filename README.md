# ruby-janken

![badge.svg](https://github.com/os1ma/ruby-janken/workflows/workflow/badge.svg)

[![Ruby Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop-hq/rubocop)

※ 記載しているコマンドは、全てプロジェクトのルートディレクトリで実行することを想定しています

## pre-commit の設定

```shell
ln -s ../../bin/pre-commit .git/hooks/pre-commit
```

## 実行

```shell
ruby ./lib/janken_cli.rb
```

## テスト

```shell
./bin/test.sh
```
