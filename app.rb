# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'haml'
require './memo'
require './memo_store'

NO_TITLE_ALERT_MESSAGE = 'タイトルが入力されていません'

helpers do
  def find_memo
    @memo_store.find(params['memo_id'])
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

  memo = @memo_store.add(params[:title], params[:body])
  redirect "/#{memo.id}"
end

get '/new' do
  @memo = Memo.new
  haml :new
end

get '/:memo_id' do
  @memo = find_memo
  haml :show
end

patch '/:memo_id' do
  redirect "#{request.path_info}/edit?no_title=true" if params[:title].empty?

  @memo_store.update(params['memo_id'], params[:title], params[:body])
  redirect request.path_info
end

delete '/:memo_id' do
  @memo_store.delete(params['memo_id'])
  redirect '/'
end

get '/:memo_id/edit' do
  @memo = find_memo
  haml :edit
end
