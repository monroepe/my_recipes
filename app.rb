require 'sinatra'
require 'sinatra/reloader'
require 'pry'
require 'pg'
require "sinatra/activerecord"

require_relative 'config/application'

Dir['app/**/*.rb'].each { |file| require_relative file }

def get_recipes(page_num)
  Recipe.where("instructions IS NOT NULL").order(:name).limit(20).offset((@page_num - 1) * 20)
end

def get_recipe(id)
  Recipe.find(id)
end

def get_ingredients(recipe_id)
  Ingredient.where("recipe_id = ?", recipe_id)
end

helpers do
  def on_last_page?(page_num)
    page_num < 32
  end

  def on_first_page?(page_num)
    page_num == 1
  end
end


get '/' do
  redirect '/recipes'
end

get '/recipes' do
  if params[:page]
    @page_num = params[:page].to_i
  else
    @page_num = 1
  end

  recipes = get_recipes(@page_num)
  erb :'recipes/index', locals: {recipes: recipes}
end

get '/recipes/:id' do
  recipe = get_recipe(params[:id])
  ingredients = get_ingredients(params[:id])
  erb :'recipes/show', locals: {recipe: recipe, ingredients: ingredients}
end

get '/search' do
  erb :'search/index'
end
