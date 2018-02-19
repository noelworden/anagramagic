#TODO NOTES takes super long, not sure how to optimize
file = 'data/dictionary.txt'
File.readlines(file).each do |line|
  word = line.strip
  Anagram.create(word: word)

  p word
end
