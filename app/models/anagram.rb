class Anagram < ApplicationRecord
  validates_presence_of :word
  validates_presence_of :letter_count

  #run before_save to get letter count in column
  before_validation :populate_letter_count

  def populate_letter_count
    self.letter_count = word.chars.count
  end
end
