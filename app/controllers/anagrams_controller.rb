class AnagramsController < ApplicationController
  before_action :set_anagram, only: [:show, :destroy]

  # curl http://localhost:3000/anagrams/`word`
  def show
    render json: @anagram, limit: params[:limit]
    #TODO need to get nil search to kick back proper ActiveRecord error mesages
  end

  # curl -X POST http://localhost:3000 -d "words=XOXO"  <- works better
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

  # curl -X "DELETE" http://localhost:3000/anagrams/tester
  def destroy
    @anagram.destroy
    head :no_content
  end

  # curl -X "DELETE" http://localhost:3000/anagrams
  def destroy_all
    Anagram.all.each(&:destroy)
    head :no_content
  end

  private

  def set_anagram
    @anagram = Anagram.find_by(word: params[:word])
  end
end
