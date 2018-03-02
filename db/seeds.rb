p "Seeding Commenced at #{Time.zone.now.in_time_zone('Eastern Time (US & Canada)').strftime("%l:%M:%S %p %Z")}"

file = 'data/dictionary.txt'
corpus = []

File.readlines(file).each do |line|
  corpus << Anagram.new(word: line.strip)
end

Anagram.import corpus

p "Seeding Concluded at #{Time.zone.now.in_time_zone('Eastern Time (US & Canada)').strftime("%l:%M:%S %p %Z")}"
