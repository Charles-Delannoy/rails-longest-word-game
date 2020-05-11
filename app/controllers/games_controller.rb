require 'pry-byebug'
require 'open-uri'
require 'json'

# Games class
class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ('A'..'Z').to_a[rand(0...('A'..'Z').to_a.size)] }
  end

  def score
    @round_points = 0
    if in_grid? && english_word?
      @response = "<strong>Congratulation!</strong> #{params[:word]} is a valid English word!".html_safe
      @round_points = params[:word].length
    elsif in_grid?
      @response = "Sorry but <strong>#{params[:word]}</strong> does not seem to be a valid English word...".html_safe
    else
      @response = "Sorry but <strong>#{params[:word]}</strong> can't be built out of #{params[:letters].split.join(', ')}".html_safe
    end
    session[:global_points] = session[:global_points] ? session[:global_points] + @round_points : @round_points
  end

  private

  def in_grid?
    grid = params[:letters].split
    params[:word].upcase.chars.each do |letter|
      return false unless grid.include? letter

      grid.delete_at(grid.index(letter))
    end
    true
  end

  def english_word?
    url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
    JSON.parse(open(url).read)['found']
  end
end
