Rails.application.routes.draw do
  # get '/anagrams' => 'anagrams#index'
  get '/anagrams/:word' => 'anagrams#show'
  post '/anagrams/' => 'anagrams#create'
  delete '/anagrams/:word' => 'anagrams#destroy'
end
