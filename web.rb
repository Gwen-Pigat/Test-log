require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'json'
require 'sinatra/reloader'if development?

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/todo_list.db")
class Item
  include DataMapper::Resource
  property :id, Serial
  property :content, Text, :required => true
  property :done, Boolean, :required => true, :default => false
  property :created, DateTime
end

DataMapper.finalize.auto_upgrade!

get '/?' do
  @items = Item.all(:order => :created.desc)
  redirect '/new' if @items.empty?
  erb :index
end

get '/new/?' do
  @title = "Votre log :"
  erb :new
end

post '/new/?' do
  Item.create(:content => params[:content], :created => Time.now)
  redirect '/'
end

post '/new/?' do
  Item.create(:prenom => params[:prenom])
  redirect '/'
end

get '/modify' do
  erb :modify
end

get '/delete/:id/?' do
  @item = Item.first(:id => params[:id])
  erb :delete
end

post '/delete/:id/?' do
  if params.has_key?("ok")
    item = Item.first(:id => params[:id])
    item.destroy
    redirect '/'
  else
    
    redirect '/'
  end
end