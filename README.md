# Sinatra Memo

## データベースの作成

```
CREATE DATABASE sinatra_memo;
```

## テーブルの作成

```
CREATE TABLE Memos (
  id     SERIAL  NOT NULL,
  title  TEXT    NOT NULL,
  body   TEXT,
  PRIMARY KEY (id)
);
```

## /.envを作成

PostgreSQLへの接続情報を設定

例
```
host=localhost
user=postgres
password=password
```

## bundle install

```
$ bundle install
```

## 実行

```
$ bundle exec ruby app.rb
```
