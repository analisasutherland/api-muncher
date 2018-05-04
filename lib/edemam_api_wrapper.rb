require 'httparty'
require 'pry'
class EdemamApiWrapper
  class EdemamError < StandardError; end
  BASE_URL = "https://api.edamam.com"
  TOKEN = ENV["EDEMAM_TOKEN"]
  API_ID = ENV["EDEMAM_ID"]

  def self.search_recipes(query)
    url = BASE_URL + "/search?q=#{query}&app_id=#{API_ID}&app_key=#{TOKEN}&from=0&to=9"
    response = HTTParty.get(url)
    raise_on_error(response)
    return response["hits"].map do |raw_recipe|
      Recipe.format_api(raw_recipe["recipe"])
    end
  end

  private
  def self.raise_on_error(response)
    unless response["hits"]
      raise EdemamError.new(response["error"])
    end
  end
end
