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

  describe 'GET /anagrams/:word' do
    before { get "/anagrams/#{word}" }

    it 'returns all anagrams' do
      expect(json).not_to be_empty
      expect(json["anagrams"]).to eq(["Dear", "Read", "dare", "read"])
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /anagrams/:word?limit=3' do
    before { get "/anagrams/#{word}/?limit=3" }

    it 'returns only non-proper nouns' do
      expect(json["anagrams"]).to eq(["Dear", "Read", "dare"])
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /anagrams/:word?proper_nouns=false' do
    before { get "/anagrams/#{word}/?proper_nouns=false" }

    it 'returns only non-proper nouns' do
      expect(json["anagrams"]).to eq(["dare", "read"])
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /anagrams/corpus-detail' do
    before { get "/corpus-detail" }

    it 'should not be an empty return' do
      expect(json).not_to be_empty
    end

    it 'displays the details of the corpus' do
      expect(json["Total Corpus Count"]).to eq("6")
      expect(json["Minimum Word Length"]).to eq("4")
      expect(json["Maximum Word Length"]).to eq("4")
      expect(json["Median Word Length"]).to eq("4.0")
      expect(json["Average Word Length"]).to eq("4.0")
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /anagram-compare' do
    it "should show `Neither words found in corpus'" do
      get "/anagram-compare", params: { words: "xxxx, yyyy"}
      expect(response.body).to eq("Neither words found in corpus")
      expect(response).to have_http_status(404)
    end

    it "should show 'first word found in corpus'" do
      get "/anagram-compare", params: { words: "xxxx, read"}
      expect(response.body).to eq("First word not found in corpus")
      expect(response).to have_http_status(404)
    end

    it "should show 'second word found in corpus'" do
      get "/anagram-compare", params: { words: "dear, yyyy"}
      expect(response.body).to eq("Second word not found in corpus")
      expect(response).to have_http_status(404)
    end

    it "should show 'first words found in corpus'" do
      get "/anagram-compare", params: { words: "dear, read"}
      expect(response.body).to eq("true")
      expect(response).to have_http_status(200)
    end

    it "should show 'first words found in corpus'" do
      get "/anagram-compare", params: { words: "dear, test"}
      expect(response.body).to eq("false")
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /anagrams-list/:integer' do
    it 'should return results if correct integer is used' do
      get "/anagrams-list/2"
      expect(json[0]).to eq(["Dear", "Read", "dare", "dear", "read"])
    end

    it 'should return 404 if incorrect integer is used' do
      get "/anagrams-list/8"
      expect(response).to have_http_status(404)
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
    it 'deletes all records' do
      expect { delete '/anagrams' }.to change(Anagram, :count).to(0)
    end

    it 'returns status code 204' do
      delete "/anagrams"
      expect(response).to have_http_status(204)
    end
  end

  describe 'DELETE_ONE /anagrams/:word/destroy_anagram' do
    it 'deletes all records' do
      expect { delete "/anagrams/#{word}/destroy_anagram" }.to change(Anagram, :count).to(1)
    end

    it 'returns status code 204' do
      delete "/anagrams"
      expect(response).to have_http_status(204)
    end
  end
end
