require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require_relative 'cookbook'
require_relative 'scrape_marmiton_service'

set :bind, '0.0.0.0'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

csv_file   = File.join(__dir__, 'recipes.csv')
cookbook   = Cookbook.new(csv_file)

get '/' do
  @cookbook = cookbook
  erb :index
end

get '/new' do
  erb :create
end

post '/recipes' do
  recipe = Recipe.new(
    name: params[:name],
    cook_time: params[:cook_time],
    difficulty: params[:difficulty]
  )
  cookbook.add_recipe(recipe)
  redirect '/'
end

delete '/destroy/:recipe_name' do
  cookbook.remove_by_name(params[:recipe_name])
  redirect '/'
end

post '/import' do
  recipes = ScrapeMarmitonService.new(params[:keyword], params[:difficulty]).call
  #list all recipes with a radio button for each one
  #return the recipe to add (radio button checked)
end


#

get '/about' do
  erb :about
end

get '/team/:username' do
  puts params[:username]
  "The username is #{params[:username]}"
end

get '/layout' do
  erb :index, :layout
end
