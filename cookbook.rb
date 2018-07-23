require 'csv'
require_relative 'recipe'

class Cookbook
  def initialize(csv_file_path)
    @csv_file_path = csv_file_path
    @recipes = []
    load_csv
  end

  def all
    @recipes
  end

  def add_recipe(recipe)
    @recipes << recipe
    rewrite_csv
  end

  def remove_recipe(recipe_index)
    @recipes.delete_at(recipe_index)
    rewrite_csv
  end

  def remove_by_name(name)
    @recipes.delete_if { |recipe| recipe.name == name }
    rewrite_csv
  end

  def load_csv
    CSV.foreach(@csv_file_path) do |row|
      @recipes << Recipe.new(
        name: row[0],
        description: row[1],
        difficulty: row[2],
        cook_time: row[3],
        ingredients: row[4],
        done: row[5] == 'true'
      )
    end
  end

  def rewrite_csv
    CSV.open(@csv_file_path, 'wb') do |csv|
      @recipes.each do |recipe|
        csv << [
          recipe.name,
          recipe.description,
          recipe.difficulty,
          recipe.cook_time,
          recipe.ingredients,
          recipe.done
        ]
      end
    end
  end
end
