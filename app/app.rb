ENV["RACK_ENV"] ||= "development"
require 'sinatra/base'
require_relative 'models/link'

class BookmarkManager < Sinatra::Base

  get '/' do
      redirect '/links'
    end

  get '/links' do
   # This uses DataMapper's .all method to fetch all
   # data pertaining to this class from the database
   @links = Link.all
   erb (:'links/index')
  end

  get '/links/new' do
    erb (:'links/new')
  end

  post '/links' do
    link = Link.create(url: params[:url],
                       title: params[:title])
      params[:tags].split.each do |tag|
      link.tags << Tag.first_or_create(name: tag)
    end
    link.save
    redirect '/links'
  end

  get '/tags/:name' do
    tag = Tag.first(name: params[:name])
    @links = tag ? tag.links : []
    erb :'links/index'
  end

  run! if app_file == $PROGRAM_NAME

end
