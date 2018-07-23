class ScrapeMarmitonService
  def initialize(keyword, filter = '0')
    @keyword = keyword
    @filter = filter
  end

  def call
    recipes = []
    urls = []

    url_search = "https://www.marmiton.org/recettes/recherche.aspx?aqt=" + @keyword
    html_doc = Nokogiri::HTML(URI.parse(url_search).open.read)

    # Urls of the recipes
    html_doc.search('div.recipe-results a.recipe-card').each do |element|
      urls << 'https://www.marmiton.org' + element.attribute('href').text
    end

    urls.each { |url| recipes << scraper_recipe(url, @filter) }
    recipes.compact.first(5)
  end

  private

  def scraper_recipe(url, filter)
    html_doc = Nokogiri::HTML(URI.parse(url).open.read)

    difficulty = html_doc.search('div.recipe-infos__level span.recipe-infos__item-title').text.strip.capitalize
    return nil unless filter == difficulty || filter.to_i.zero?

    name = html_doc.search('h1').text.strip
    cook_time = html_doc.search('span.recipe-infos__total-time__value').text.strip


    desc = scrape_description(html_doc)

    ingredients = scrape_ingredients(html_doc)

    Recipe.new(name: name, description: desc, difficulty: difficulty, cook_time: cook_time, ingredients: ingredients)
  end

  def scrape_ingredients(doc)
    ingredients = ''
    doc.search('h4.recipe-ingredients__group-title').each do |group|
      ingredients << "\n\t<--" << group.text.strip << "-->\n"

      doc.search('li.recipe-ingredients__list__item').each do |element|
        ingredients << element.search('span.recipe-ingredient-qt').text.strip << ' '
        ingredients << element.search('span.ingredient').text.strip << ' '
        ingredients << element.search('span.recipe-ingredient__complement').text.strip << "\n"
      end
    end
    ingredients
  end

  def scrape_description(doc)
    description = ''
    doc.search('li.recipe-preparation__list__item').each do |element|
      description << element.text.strip.tr("\t\t", "\n") << "\n\n"
    end
    description
  end
end
