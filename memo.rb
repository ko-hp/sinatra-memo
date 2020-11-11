# frozen_string_literal: true

require 'securerandom'

class Memo
  attr_reader :id, :title, :body

  def initialize(id = '', title = '', body = '')
    @id = id
    @title = title
    @body = body
  end
end
