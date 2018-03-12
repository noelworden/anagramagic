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

class AnagramSerializer < ActiveModel::Serializer
  attributes :anagrams

  #TODO add actual word to be anagrammed
  def anagrams
    limit = @instance_options[:limit].to_i
    proper_nouns = @instance_options[:proper_nouns]
    base = object.word

    sorted_object = base.split('').sort.join

    if proper_nouns == 'false'
      anagram = Anagram.where(sorted_word: sorted_object, proper_noun: false).pluck(:word) - [base]
    else
      anagram = Anagram.where(sorted_word: sorted_object).pluck(:word) - [base]
    end

    if limit == 0
      anagram.sort
    else
      anagram.sort.first(limit)
    end
  end
end
