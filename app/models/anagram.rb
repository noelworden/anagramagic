# == Schema Information
#
# Table name: anagrams
#
#  id          :integer          not null, primary key
#  word        :string
#  sorted_word :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  word_length :integer
#  proper_noun :boolean          default(FALSE)
#

class Anagram < ApplicationRecord
  validates :word, presence: true, uniqueness: true
  validates_presence_of :sorted_word, :word_length
  before_validation :sort_word, :word_length, :proper_noun

  def sort_word
    self.sorted_word = word.downcase.chars.sort.join
  end

  def word_length
    self.word_length = word.chars.count
  end

  def proper_noun
    self.proper_noun = word.first == word.first.capitalize
  end
end
