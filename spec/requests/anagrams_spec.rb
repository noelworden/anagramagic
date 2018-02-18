require 'rails_helper'

RSpec.describe 'Anagrams API', type: :request do
  let!(:anagrams) {
                    Anagram.create(word: "dear")
                    Anagram.create(word: "dare")
                    Anagram.create(word: "read")
                    }
  let(:word) { Anagram.first.word }

  describe 'GET /anagrams/:word' do
    before { get "/anagrams/#{word}" }

    context 'when record exists' do
      it 'returns the word' do
        expect(json).not_to be_empty
        expect(json["anagrams"]).to eq(["dare", "read"])
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET /anagrams/corpus-detail' do
    before { get "/corpus-detail" }

    it 'should not be an empty return'do
      expect(json).not_to be_empty
    end

    it 'displays the details of the corpus' do
      expect(json["Total Corpus Count"]).to eq("3")
      expect(json["Minimum Word Length"]).to eq("4")
      expect(json["Maximum Word Length"]).to eq("4")
      expect(json["Median Word Length"]).to eq("4.0")
      expect(json["Average Word Length"]).to eq("4.0")
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /' do
    let (:valid_attributes) { { words: "test01, test02" } }
    let (:original_count) { Anagram.count }

    # before { post '/', params: valid_attributes }
    # TODO NOTES had difficulty using 'before' when trying to get a database count
    it 'increases Anagram count by 2' do
      expect {
        post '/', params: valid_attributes
      }.to change(Anagram, :count).by(2)
    end

    it 'returns status code 201' do
      post '/', params: valid_attributes
      expect(response).to have_http_status(201)
    end
  end

  describe 'DELETE /anagrams/:word' do
    # before { delete "/anagrams/#{word}" }
    it 'deletes a single record' do
      expect { delete "/anagrams/#{word}" }.to change(Anagram, :count).by(-1)
    end

    it 'returns status code 204' do
      delete "/anagrams/#{word}"
      expect(response).to have_http_status(204)
    end
  end

  describe 'DELETE_ALL /anagrams/' do
    # before { delete "/anagrams/#{word}" }
    it 'deletes all records' do
      expect { delete '/anagrams' }.to change(Anagram, :count).to(0)
    end

    it 'returns status code 204' do
      delete "/anagrams"
      expect(response).to have_http_status(204)
    end
  end
end
