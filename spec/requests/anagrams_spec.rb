require 'rails_helper'

RSpec.describe 'Anagrams API', type: :request do
  let!(:anagrams) {
                    Anagram.create(word: "dear")
                    Anagram.create(word: "dare")
                    Anagram.create(word: "read")
                    Anagram.create(word: "Read")
                    Anagram.create(word: "Dear")
                    Anagram.create(word: "test")
                    }
  let(:word) { Anagram.first.word }

  describe 'GET /api/v1/anagrams/:word' do
    before { get "/api/v1/anagrams/#{word}" }

    it 'returns all anagrams' do
      expect(json).not_to be_empty
      expect(json["anagrams"]).to eq(["Dear", "Read", "dare", "read"])
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /api/v1/anagrams/:word?limit=3' do
    before { get "/api/v1/anagrams/#{word}/?limit=3" }

    it 'returns only non-proper nouns' do
      expect(json["anagrams"]).to eq(["Dear", "Read", "dare"])
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /api/v1/anagrams/:word?proper_nouns=false' do
    before { get "/api/v1/anagrams/#{word}/?proper_nouns=false" }

    it 'returns only non-proper nouns' do
      expect(json["anagrams"]).to eq(["dare", "read"])
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /api/v1/anagram-compare' do
    it "should show error if only one entry" do
      get "/api/v1/anagram-compare", params: { words: "yyyy"}
      expect(json["error"]).to eq("Please check your word count, you need exactly two words")
      expect(response).to have_http_status(404)
    end

    it "should show error if more than two entries" do
      get "/api/v1/anagram-compare", params: { words: "xxxx, yyyy, zzzz"}
      expect(json["error"]).to eq("Please check your word count, you need exactly two words")
      expect(response).to have_http_status(404)
    end

    it "should show 'false' if pair of words are not anagrams" do
      get "/api/v1/anagram-compare", params: { words: "dear, yyyy"}
      expect(response.body).to eq("false")
      expect(response).to have_http_status(200)
    end

    it "should show 'true' if pair of words are anagrams" do
      get "/api/v1/anagram-compare", params: { words: "dear, read"}
      expect(response.body).to eq("true")
      expect(response).to have_http_status(200)
    end
  end


  describe 'GET /api/v1/anagrams/corpus-detail' do
    before { get "/api/v1/corpus-detail" }

    it 'should not be an empty return' do
      expect(json).not_to be_empty
    end

    it 'displays the details of the corpus' do
      expect(json["Total Corpus Count"]).to eq(6)
      expect(json["Minimum Word Length"]).to eq(4)
      expect(json["Maximum Word Length"]).to eq(4)
      expect(json["Median Word Length"]).to eq(4.0)
      expect(json["Average Word Length"]).to eq(4.0)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /api/v1/anagrams-list/:integer' do
    it 'should return results if correct integer is used' do
      get '/api/v1/anagrams-list/2'
      expect(json[0]).to eq(%w[Dear Read dare dear read])
    end

    it 'should return 404 if integer is too high' do
      get '/api/v1/anagrams-list/8'
      expect(response).to have_http_status(404)
    end
  end

  describe 'GET /big-ol-anagram' do
    it 'should list of largest anagram' do
      get '/api/v1/big-ol-anagram'
      expect(json).to eq(%w[Dear Read dare dear read])
    end
  end

  describe 'POST /api/v1/anagrams' do
    let :valid_attributes { { "words": ["wordx", "wordz"] } }

    it 'increases Anagram count by 2' do
      expect {
        post '/api/v1/anagrams', params: valid_attributes
      }.to change(Anagram, :count).by(2)
    end

    it 'returns status code 201' do
      post '/api/v1/anagrams', params: valid_attributes
      expect(response).to have_http_status(201)
    end
  end

  describe 'DELETE /api/v1/anagrams/:word' do
    it 'deletes a single record' do
      expect {
        delete "/api/v1/anagrams/#{word}"
      }.to change(Anagram, :count).by(-1)
    end

    it 'returns status code 204' do
      delete "/api/v1/anagrams/#{word}"
      expect(response).to have_http_status(204)
    end
  end

  describe 'DELETE_ALL /api/v1/anagrams/' do
    it 'deletes all records' do
      expect {
        delete '/api/v1/destroy-all-anagrams'
      }.to change(Anagram, :count).to(0)
    end

    it 'returns status code 204' do
      delete '/api/v1/destroy-all-anagrams'
      expect(response).to have_http_status(204)
    end
  end

  describe 'DELETE_ONE /api/v1/anagrams/:word/destroy_anagram' do
    it 'deletes all records' do
      expect {
        delete "/api/v1/anagrams/#{word}/destroy_anagram"
      }.to change(Anagram, :count).to(1)
    end

    it 'returns status code 204' do
      delete "/api/v1/anagrams/#{word}/destroy_anagram"
      expect(response).to have_http_status(204)
    end
  end
end
