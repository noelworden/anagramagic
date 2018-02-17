class AnagramsController < ApplicationController
  before_action :set_anagram, only: [:show, :destroy]

  # curl http://localhost:3000/anagrams
  def index
    @anagrams = Anagram.all
    json_response(@anagrams)
    #TODO loose this action
  end

  # curl http://localhost:3000/anagrams/`word`
  def show
    json_response(@anagram)
    #TODO need to get nil search to kick back proper ActiveRecord error mesages
  end

  # curl --data "word=testingcurl" http://localhost:3000/anagrams
  def create
    @anagram = Anagram.create!(anagram_params)
    json_response(@anagram, :created)
  end

  # curl -X "DELETE" http://localhost:3000/anagrams/tester
  def destroy
    @anagram.destroy
    head :no_content
  end

  private

  def set_anagram
    @anagram = Anagram.find_by(word: params[:word])
  end

  def anagram_params
    params.permit(:word, :letter_count)
  end
end
