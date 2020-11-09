require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @letters = generate_grid(10)
  end

  def score
    params[:letters] = params[:letters].gsub(" ", "").chars
    @result = run_game(params[:word], params[:letters])
  end

  private

  def generate_grid(grid_size)
    source = ("a".."z").to_a
    key = []
    grid_size.times { key << source[rand(source.size)].to_s }
    return key
  end

  def run_game(attempt, grid)
    response = open("https://wagon-dictionary.herokuapp.com/#{attempt}").read
    hash_response = JSON.parse(response)
    if hash_response['error'] == 'word not found'
      { score: 0, message: "Sorry but #{attempt.upcase} does not seem to be a valid English word..." }
    elsif attempt.chars.any? { |char| attempt.chars.count(char) > grid.count(char) }
      { score: 0, message: "Sorry but #{attempt.upcase} can't be build out of #{grid.join(',')}" }
    else
      { score: (hash_response['length']), message: "Congratulations! #{attempt.upcase} is a valid English word!" }
    end
  end
end

# TODO: generate random grid of letters
