Rails.application.routes.draw do
  get '/anagrams' => 'anagrams#index'
  get '/anagrams/:word' => 'anagrams#show'
end
