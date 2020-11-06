# frozen_string_literal: true

require 'dotenv/load'
require 'pg'
require './memo'

class MemoStore
  def add(title, body)
    connect_pg do |connection|
      connection.exec('INSERT INTO Memos (title, body) VALUES ($1, $2)', [title, body])
      id = connection.exec("SELECT currval('memos_id_seq')").first['currval']
      Memo.new(id, title, body)
    end
  end

  def update(id, title, body)
    sql('UPDATE Memos SET title = $1, body = $2 WHERE id = $3', [title, body, id])
  end

  def delete(id)
    sql('DELETE FROM Memos WHERE id = $1', [id])
  end

  def find(id)
    row = sql('SELECT id, title, body FROM Memos WHERE id = $1', [id]).first
    MemoStore.db_row_to_memo(row)
  end

  def all_memos
    sql('SELECT id, title, body FROM Memos ORDER BY id').map do |row|
      MemoStore.db_row_to_memo(row)
    end
  end

  def self.db_row_to_memo(row)
    Memo.new(row['id'], row['title'], row['body'])
  end

  private

  def connect_pg
    connection = PG.connect(host: ENV['host'], user: ENV['user'], password: ENV['password'], dbname: 'sinatra_memo')
    ret = yield(connection)
    connection.finish
    ret
  end

  def sql(query, values = [])
    connect_pg { |connection| connection.exec(query, values) }
  end
end
