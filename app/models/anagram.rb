class Anagram < ApplicationRecord
  validates_presence_of :word
  validates_uniqueness_of :word
  validates_presence_of :sorted_word

  #run before_save to get letter count in column
  before_validation :sort_word

  def sort_word
    self.sorted_word = word.chars.sort.join
  end
end
