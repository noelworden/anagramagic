class AnagramsController < ApplicationController
  before_action :set_anagram, only: [:show]
  def index
    @anagrams = Anagram.all
    json_response(@anagrams)
  end

  def show
    json_response(@anagram)
  end

  private

  def set_anagram
    @anagram = Anagram.find_by(word: params[:word])
  end
end
