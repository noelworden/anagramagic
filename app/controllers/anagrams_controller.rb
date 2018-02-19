class AnagramsController < ApplicationController
  before_action :set_anagram, only: [:show, :destroy, :destroy_anagram]

  # curl http://localhost:3000/anagrams/:word?limit=:integer&proper_nouns=false
  def show
    if @anagram == nil
      render status: 404
    else
      render json: @anagram, limit: params[:limit], proper_nouns: params[:proper_nouns]
    end
  end

  # curl -X GET http://localhost:3000/anagram-compare -d "words={word1, word2}"
  def compare
    array = params[:words].gsub(/{|}/, '').split(", ")
    first_word = Anagram.find_by(word: array[0])
    second_word = Anagram.find_by(word: array[1])

    if first_word == nil && second_word == nil
      render json: "Neither words found in corpus", status: 404
    elsif first_word == nil
      render json: "First word not found in corpus", status: 404
    elsif second_word == nil
      render json: "Second word not found in corpus", status: 404
    elsif first_word.sorted_word == second_word.sorted_word
      render json: "true", status: 200
    else
      render json: "false", status: 200
    end
  end

  # curl http://localhost:3000/corpus-detail
  def corpus_detail
    word_lengths = Anagram.all.pluck(:word_length)

    render json: { "Total Corpus Count": "#{Anagram.all.count}",
                   "Minimum Word Length": "#{word_lengths.min}",
                   "Maximum Word Length": "#{word_lengths.max}",
                   "Median Word Length": "#{median(word_lengths)}",
                   "Average Word Length": "#{(word_lengths.sum.to_f / word_lengths.count.to_f).round(3)}"
                 }, status: 200
  end

  # curl http://localhost:3000/anagrams-list/:integer
  def list
    final_array = []

    sorted_word_array = Anagram.all.pluck(:sorted_word)
    anagrams_array = sorted_word_array.group_by(&:itself).select{|_key, value| value.count >= params[:integer].to_i }.keys

    if anagrams_array == []
      render status: 404
    else
      anagrams_array.each do |anagram|
        final_array << Anagram.where(sorted_word: anagram).pluck(:word).sort
      end

      render json: final_array
    end
  end

  # curl http://localhost:3000/big-ol-anagram
  def maximum
    sorted_word_array = Anagram.all.pluck(:sorted_word)
    largest_anagram = sorted_word_array.group_by(&:itself).sort_by {|_key, value| value.count}.last[0]

    render json: "#{Anagram.where(sorted_word: largest_anagram).pluck(:word).sort}", status: 201
  end

  # curl -X POST http://localhost:3000 -d "words={word1, word2}"
  def create
    # TODO NOTES couldnt find a way that Rails did this automatically,
    # kept getting errors stating a status could only be shown once per action
    success = []
    array = params[:words].gsub(/{|}/, '').split(", ")

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

  def anagram_params
    params.permit(:words)
  end

  def set_anagram
    @anagram = Anagram.find_by(word: params[:word])
  end

  def median(array)
    sorted = array.sort
    length = sorted.length
    (sorted[(length - 1) / 2] + sorted[length / 2]) / 2.0
  end
end
