# ruby-janken

[![main](https://github.com/os1ma/ruby-janken/actions/workflows/main.yaml/badge.svg)](https://github.com/os1ma/ruby-janken/actions/workflows/main.yaml)

[![Ruby Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop-hq/rubocop)

※ 記載しているコマンドは、全てプロジェクトのルートディレクトリで実行することを想定しています

## pre-commit の設定

```shell
ln -s ../../bin/pre-commit .git/hooks/pre-commit
```

## コンテナの起動

```shell
docker-compose up -d
docker-compose exec ruby bash
```

## CLI アプリケーションの実行

```shell
bundle exec ruby ./app/janken_cli.rb
```

## 自動テスト・静的解析

```shell
./bin/test.sh
```

## Rack アプリケーションの起動と動作確認

```shell
bundle exec rackup config.ru -o 0.0.0.0
```

```shell
curl localhost:9292/api/health
curl -X POST -d '{"player1Id": 1, "player1Hand": 0, "player2Id": 2, "player2Hand": 1}' localhost:9292/api/jankens
```
