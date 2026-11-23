require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    random_string = ("A".."Z").to_a
    length = 10
    @letters = Array.new(length) { random_string.sample }
  end

  def score
    @word = params[:word].upcase
    @memoryletters = params[:letters]
    if !in_grid?(@word, @memoryletters)
      @result = "Sorry but #{@word} can't be built out of #{@memoryletters.chars.join(', ')}"
    elsif !english_word?(@word)
      @result = "Sorry but #{@word} does not seem to be a valid English word..."
    else
      @result = "Congratulations! #{@word} is a valid English word!"
    end
  end

  private

  def in_grid?(word, grid)
    word.chars.all? { |letter| word.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    url = "https://dictionary.lewagon.com/#{word}"
    response = URI.parse(url).read
    json = JSON.parse(response)
    json["found"]
  end
end
