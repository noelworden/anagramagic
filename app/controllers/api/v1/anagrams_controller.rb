module Api
  module V1
    class AnagramsController < ApplicationController
      before_action :set_anagram, only: [:show, :destroy, :destroy_anagram]

      # curl http://localhost:3000/api/v1/anagrams/:word?limit=:integer&proper_nouns=false
      def show
        if @anagram.nil?
          render json: { error: 'That word does not exist in the corpus' }, status: 404
        else
          render json: @anagram, limit: params[:limit], proper_nouns: params[:proper_nouns]
        end
      end

      # curl -X GET http://localhost:3000/api/v1/anagram-compare -d "words={ word1, word2 }"
      # TODO get this action to function similar to `create`
      # def compare
      #   words = params[:words].gsub(/{|}/, '').split(", ")
      #
      #   if words.count != 2
      #     render json: { error: 'Please check your word count, you need exactly two words' }, status: 404
      #   else
      #     first_word = words[0].downcase.chars.sort.join
      #     second_word = words[1].downcase.chars.sort.join
      #
      #     render json: first_word == second_word, status: 200
      #   end
      # end

      # curl http://localhost:3000/api/v1/corpus-detail
      def corpus_detail
        #TODO pull out of Controller
        #TODO min/max/median can be done in postgres
        word_lengths = Anagram.all.pluck(:word_length)

        render json: { 'Total Corpus Count': Anagram.all.count,
                       'Minimum Word Length': word_lengths.min,
                       'Maximum Word Length': word_lengths.max,
                       'Median Word Length': median(word_lengths),
                       'Average Word Length': (word_lengths.sum.to_f / word_lengths.count.to_f).round(3)
                     }, status: 200
      end

      # curl http://localhost:3000/api/v1/anagrams-list/:integer
      def list
        final_array = []
        sorted_word_array = Anagram.all.pluck(:sorted_word)
        # Create hash of matching `sorted_words` then select all with value count
        # less then or greater to the given parameter, then grab those keys
        anagrams_array = sorted_word_array
                          .group_by(&:itself)
                          .select{|_key, value| value.count >= params[:integer].to_i }
                          .keys

        if anagrams_array == []
          render json: { error: 'There are no angrams of that length, check your integer' }, status: 404
        else
          anagrams_array.each { |anagram| final_array << Anagram
                                                        .where(sorted_word: anagram)
                                                        .pluck(:word).sort
                                                      }
          render json: final_array, status: 200
        end
      end

      # curl http://localhost:3000/api/v1/big-ol-anagram
      def maximum
        sorted_word_array = Anagram.all.pluck(:sorted_word)
        # Create hash of matching `sorted_words`, then sort by the number of values,
        # and grab last (and largest) key
        largest_anagram = sorted_word_array
                          .group_by(&:itself)
                          .sort_by {|_key, value| value.count}
                          .last[0]

        render json: "#{Anagram.where(sorted_word: largest_anagram).pluck(:word).sort}", status: 201
      end

      # curl -H "Content-Type: application/json" -X POST -d '{"words": ["wordx", "wordz"]}' http://localhost:3001/api/v1/anagrams
      #TODO not @anagram, its a word
      #TODO activerecord transaction
      def create
        anagrams = Anagram.create_multiple(params[:words])
        if anagrams.present?
          render json: anagrams, status: 201
        else
          head :no_content, status: 400
        end
      end

      # curl -X DELETE http://localhost:3000/api/v1/anagrams/:word
      def destroy
        if @anagram.nil?
          render json: { error: 'That word does not exist in the corpus' }, status: 404
        else
          @anagram.destroy
          head :no_content
        end
      end

      # curl -X DELETE http://localhost:3000/api/v1/destroy-all-anagrams
      def destroy_all
        Anagram.delete_all
        head :no_content
      end

      # curl -X DELETE http://localhost:3000/api/v1/anagrams/:word/destroy_anagram
      def destroy_anagram
        if @anagram.nil?
          render json: { error: 'That word does not exist in the corpus' }, status: 404
        else
          Anagram.remove_all_anagrams(@anagram.sorted_word)
          render status: 204
        end
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
  end
end
