#TODO change this for actual dictionary
#TODO should it be downcasing everything? If so they should be unique
file = 'data/mini_dictionary.txt'
File.readlines(file).each do |line|
  word = line.downcase.strip
  Anagram.create(word: word, count: word.chars.count)

  p word
end
