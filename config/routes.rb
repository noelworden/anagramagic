Rails.application.routes.draw do
  #TODO get into api/v1
  # get '/anagrams' => 'anagrams#index'
  get '/anagrams/:word' => 'anagrams#show'
  post '/' => 'anagrams#create'
  delete '/anagrams/:word' => 'anagrams#destroy'
  delete '/anagrams' => 'anagrams#destroy_all'
end
