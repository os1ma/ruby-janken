# ruby-janken

![badge.svg](https://github.com/os1ma/ruby-janken/workflows/workflow/badge.svg)

[![Ruby Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop-hq/rubocop)

※ 記載しているコマンドは、全てプロジェクトのルートディレクトリで実行することを想定しています

## pre-commit の設定

```shell
ln -s ../../bin/pre-commit .git/hooks/pre-commit
```

## CLI アプリケーションの実行

```shell
docker-compose up -d
bundle exec ruby ./app/janken_cli.rb
```

## 自動テスト・静的解析

```shell
./bin/test.sh
```

## Rack アプリケーションの起動と動作確認

```shell
bundle exec rackup config.ru
```

```shell
curl localhost:9292/api/health
curl -X POST -d '{"player1Id": 1, "player1Hand": 0, "player2Id": 2, "player2Hand": 1}' localhost:9292/api/jankens
```

## Heroku へのデプロイ

```shell
heroku git:remote -a "${HEROKU_APP_NAME}"
git push heroku main
```

参考

- [Git を使用したデプロイ](https://devcenter.heroku.com/ja/articles/git)
- [Deploying Rack-based Apps](https://devcenter.heroku.com/articles/rack)
