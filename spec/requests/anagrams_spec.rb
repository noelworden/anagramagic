require 'rails_helper'

RSpec.describe 'Anagrams API', type: :request do
  let!(:anagrams) {
                    Anagram.create(word: "dear", letter_count: 4)
                    Anagram.create(word: "dare", letter_count: 4)
                    Anagram.create(word: "read", letter_count: 4)
                    }
  let(:word) { Anagram.first.word }

  # describe 'GET /anagrams' do
  #   before { get '/anagrams'}
  #
  #   it 'returns anagrams' do
  #     expect(json).not_to be_empty
  #     expect(json.size).to eq(3)
  #   end
  #
  #   it 'returns status code 200' do
  #     expect(response).to have_http_status(200)
  #   end
  # end

  describe 'GET /anagrams/:word' do
    before { get "/anagrams/#{word}" }

    context 'when record exists' do
      it 'returns the word' do
        #TODO should return word AND anagrams
        expect(json).not_to be_empty
        expect(json["word"]).to eq(word)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    # context 'when record does not exist' do
    #   let(:word) { "sassafras" }
    #
    #   it 'returns nil' do
    #     #TODO this needs to change to 404
    #     # expect(json).to be(nil)
    #     expect(json).to have_http_status(404)
    #   end
    # end
  end

  describe 'POST /anagrams' do
    let (:valid_attributes) { { word: "bessy" } }

    context 'when the request is valid' do
      before { post '/anagrams', params: valid_attributes }

      it 'creates a new anagram record' do
        expect(json["word"]).to eq("bessy")
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end
  end

  describe 'DELETE /anagrams/:word' do
    before { delete "/anagrams/#{word}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
