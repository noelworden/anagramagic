class AnagramsController < ApplicationController
  before_action :set_anagram, only: [:show, :destroy, :destroy_anagram]

  # curl http://localhost:3000/anagrams/:word?limit:__&proper_nouns=false
  def show
    render json: @anagram, limit: params[:limit], proper_nouns: params[:proper_nouns]
    #TODO need to get nil search to kick back proper ActiveRecord error mesages
  end

  def corpus_detail
    word_lengths = Anagram.all.pluck(:word_length)

    render json: { "Total Corpus Count": "#{Anagram.all.count}",
                   "Minimum Word Length": "#{word_lengths.min}",
                   "Maximum Word Length": "#{word_lengths.max}",
                   "Median Word Length": "#{median(word_lengths)}",
                   "Average Word Length": "#{(word_lengths.sum.to_f / word_lengths.count.to_f).round(3)}"
                 }, status: 200
  end

  # curl -X POST http://localhost:3000 -d "words=XOXO"
  def create
    # TODO NOTES couldnt find a way that Rails did this automatically,
    # kept getting errors stating a status could only be shown once per action
    success = []
    array = params[:words].split(", ")

    array.each do |word|
      @anagram = Anagram.create!(word: word)
      if @anagram.save
        success << @anagram
      end
    end

    #will automatically break and display error, only setting up for success message
    render json: success.to_json, status: 201
  end

  # curl -X "DELETE" http://localhost:3000/anagrams/:word
  def destroy
    @anagram.destroy
    head :no_content
  end

  # curl -X "DELETE" http://localhost:3000/anagrams
  def destroy_all
    Anagram.all.each(&:destroy)
    head :no_content
  end

  # curl -X "DELETE" http://localhost:3000/anagrams/:word/destroy_anagram
  def destroy_anagram
    array = Anagram.where(sorted_word: @anagram.sorted_word)

    array.each do |anagram|
      anagram.destroy
    end

    render status: 204
  end

  private

  def set_anagram
    @anagram = Anagram.find_by(word: params[:word])
  end

  def median(array)
    sorted = array.sort
    length = sorted.length
    (sorted[(length - 1) / 2] + sorted[length / 2]) / 2.0
  end
end
