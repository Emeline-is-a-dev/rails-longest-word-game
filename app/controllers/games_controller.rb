require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = Array.new(10){ [*"A".."Z"].sample }
  end

  def score
    @score = 0
    @word = params[:word]
    @letters = params[:letters]
    if english_word(@word) == true && valid_word?(@word, @letters) == true
      @result = 'You won!'
    elsif valid_word?(@word, @letters) == true && english_word(@word) == false
      @result =  'This word is not an english valid word'
    elsif valid_word?(@word, @letters) == false
      @result =  'You build wrong !'
    end
  end

  def english_word(word)
    encoded_word = URI.encode_www_form_component(word)
    url = URI.open("https://wagon-dictionary.herokuapp.com/#{encoded_word}").read
    json_response = JSON.parse(url)
    json_response['found']
  end

  def valid_word?(word, letters)
    word.upcase.chars.all? { |letter| letters.include?(letter) && letters.count(letter) >= word.upcase.count(letter) }
  end
end
