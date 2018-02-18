Rails.application.routes.draw do
  #TODO get into api/v1
  # get '/anagrams' => 'anagrams#index'
  get '/anagrams/:word' => 'anagrams#show'
  #TODO NOTES had to name it something with a hyphen, becuase it would otherwise be interfere with dicitonary words
  get '/corpus-detail' => 'anagrams#corpus_detail'
  get '/anagram-compare' => 'anagrams#compare'
  post '/' => 'anagrams#create'
  delete '/anagrams/:word' => 'anagrams#destroy'
  delete '/anagrams' => 'anagrams#destroy_all'
  delete '/anagrams/:word/destroy_anagram' => 'anagrams#destroy_anagram'
end
