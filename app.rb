# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'haml'
require './memo'
require './memo_store'

NO_TITLE_ALERT_MESSAGE = 'タイトルが入力されていません'

helpers do
  def find_memo
    @memo_store.find(params['memo_uuid'])
  end
end

before do
  @memo_store = MemoStore.new
  @alert = NO_TITLE_ALERT_MESSAGE if params[:no_title]
end

get '/' do
  @memos = @memo_store.all_memos
  haml :index
end

post '/' do
  redirect '/new?no_title=true' if params[:title].empty?

  memo = Memo.new(params[:title], params[:body])
  @memo_store.add(memo)
  redirect "/#{memo.uuid}"
end

get '/new' do
  @memo = Memo.new('', '')
  haml :new
end

get '/:memo_uuid' do
  @memo = find_memo
  haml :show
end

patch '/:memo_uuid' do
  @memo = find_memo
  redirect "/#{@memo.uuid}/edit?no_title=true" if params[:title].empty?

  @memo.title = params[:title]
  @memo.body = params[:body]
  @memo_store.update(@memo)
  redirect "/#{@memo.uuid}"
end

delete '/:memo_uuid' do
  @memo = find_memo
  @memo_store.delete(@memo)
  redirect '/'
end

get '/:memo_uuid/edit' do
  @memo = find_memo
  haml :edit
end
