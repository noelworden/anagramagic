file = 'data/dictionary.txt'
File.readlines(file).each do |line|
  word = line.strip
  Anagram.create(word: word)

  p word
end
