Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      #TODO get into api/v1
      get '/anagrams/:word' => 'anagrams#show'
      #TODO NOTES had to name it something with a hyphen, becuase it would otherwise be interfere with dicitonary words
      get '/anagram-compare' => 'anagrams#compare'
      get '/corpus-detail' => 'anagrams#corpus_detail'
      get '/anagrams-list/:integer' => 'anagrams#list'
      get '/big-ol-anagram' => 'anagrams#maximum'
      post '/anagrams' => 'anagrams#create'
      delete '/anagrams/:word' => 'anagrams#destroy'
      delete '/anagrams' => 'anagrams#destroy_all'
      delete '/anagrams/:word/destroy_anagram' => 'anagrams#destroy_anagram'
    end
  end
end
