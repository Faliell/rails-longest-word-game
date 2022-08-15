require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @letters = generate_grid(10)
    @start_time = Time.now
  end

  def score
    @letters = params[:letters].split(" ")
    @word = params[:word]
    attempt = params[:word]
    start_time = Time.parse(params[:start_time])
    end_time = Time.now

    @result = run_game(attempt, @letters, start_time, end_time)
  end
end

def generate_grid(grid_size)
  # TODO: generate random grid of letters
  array_letter = []
  while grid_size > array_letter.size
    letter = ("A".."Z").to_a.sample(1)
    array_letter << letter
  end
  array_letter
end

def run_game(attempt, grid, start_time, end_time)
  # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)
  data_word = JSON.parse(URI.open("https://wagon-dictionary.herokuapp.com/#{attempt}").read)
  time_final = end_time - start_time

  if data_word["found"] && compare(grid, attempt)
    score_final = (attempt.size * 100) - time_final
    message_final = "well done"
  else
    score_final = 0
    message_final = "not an english word or a word not in the grid"
  end

  return { time: time_final, score: score_final, message: message_final }
end

def compare(grid, word)
  array_word = word.upcase.chars
  valid_word = true

  array_word.each do |letter|
    valid_word = false unless grid.include?(letter)
    index = grid.index(letter) if grid.include?(letter)
    grid.delete_at(index) if grid.include?(letter)
  end
  valid_word
end
