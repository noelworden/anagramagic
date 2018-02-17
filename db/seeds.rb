#TODO change this for actual dictionary
#TODO should it be downcasing everything? If so they should be unique
file = 'data/mini_dictionary.txt'
File.readlines(file).each do |line|
  Anagram.create(word: line.downcase.strip)

  p word
end
