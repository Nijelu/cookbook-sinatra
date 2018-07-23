class Recipe
  attr_reader :name, :description, :difficulty, :cook_time, :ingredients, :done

  def initialize(attributes = {})
    @name = attributes[:name]
    @description = attributes[:description]
    @difficulty = attributes[:difficulty]
    @cook_time = attributes[:cook_time]
    @ingredients = attributes[:ingredients]
    @done = false
  end

  def mark_as_done!
    @done = true
  end
end
