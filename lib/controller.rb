require 'gossip'

class ApplicationController < Sinatra::Base
  get '/' do
    erb :index, locals: { gossips: Gossip.all }
  end

  get '/gossips/new' do
    erb :new_gossip
  end

  get '/gossips/:id' do
    erb :show, locals: { gossip: Gossip.find(params['id'].to_i - 1), id: params['id'] }
  end

  post '/gossips/new' do
    Gossip.new(params['gossip_author'], params['gossip_content']).save
    redirect '/'
  end

  get '/gossips/:id/edit' do
    erb :edit, locals: { gossip: Gossip.find(params['id'].to_i - 1), id: params['id'] }
  end

  post '/gossips/:id/edit' do
    Gossip.update(params['id'], params['gossip_author'], params['gossip_content'])
    redirect '/'
  end

  get '/gossips/:id/comment' do
    erb :comment, locals: { gossip: Gossip.find(params['id'].to_i - 1), id: params['id'] }
  end

  post '/gossips/:id/comment' do
    Gossip.add_comment(params['id'], params['comment_author'], params['comment_content'])
    redirect '/'
  end
end
