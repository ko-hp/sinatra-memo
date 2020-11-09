# frozen_string_literal: true

require 'csv'
require './memo'

class MemoStore
  FILENAME = 'data.csv'
  HEADERS = %i[title body uuid].freeze

  def initialize
    @table = File.exist?(FILENAME) ? CSV.table(FILENAME) : CSV::Table.new([])
  end

  def add(memo)
    @table << memo.to_csv_row(HEADERS)
    save
  end

  def update(memo)
    @table[find_index(memo.uuid)] = memo.to_csv_row(HEADERS)
    save
  end

  def delete(memo)
    @table.delete(find_index(memo.uuid))
    save
  end

  def find(uuid)
    MemoStore.row_to_memo(@table[find_index(uuid)])
  end

  def all_memos
    @table.map { |row| MemoStore.row_to_memo(row) }
  end

  def self.row_to_memo(row)
    Memo.new(row[:title], row[:body], row[:uuid])
  end

  private

  def find_index(uuid)
    @table[:uuid].find_index(uuid)
  end

  def save
    File.write(FILENAME, @table)
  end
end
