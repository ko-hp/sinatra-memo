# frozen_string_literal: true

require 'csv'
require 'securerandom'

class Memo
  attr_accessor :title, :body
  attr_reader :uuid

  def initialize(title, body, uuid = SecureRandom.uuid)
    @title = title
    @body = body
    @uuid = uuid
  end

  def to_csv_row(headers)
    CSV::Row.new(headers, headers.map { |header| send(header) })
  end
end
