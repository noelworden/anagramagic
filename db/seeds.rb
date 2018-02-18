#TODO change this for actual dictionary
#TODO should it be downcasing everything? If so they should be unique
#TODO NOTES takes super long, not sure how to optimize
file = 'data/mini_dictionary.txt'
File.readlines(file).each do |line|
  word = line.strip
  Anagram.create(word: word)

  p word
end
