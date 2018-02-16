class Anagram < ApplicationRecord
  validates_presence_of :word
  validates_presence_of :count
end
