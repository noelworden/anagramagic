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

require 'rails_helper'

RSpec.describe Anagram, type: :model do
  describe 'creating a valid record' do
    anagram = Anagram.new(word: "test")

    it 'is valid with valid attributes' do
      expect(anagram).to be_valid
    end

    it "should automatically create 'sorted_word' attribute" do
      expect(anagram.sorted_word).to_not be_empty
    end

    it "should automatically create 'word_length' attribute" do
      expect(anagram.word_length).to eq(4)
    end

    it 'should fail if its a duplicate word' do
      anagram1 = Anagram.create(word: "testx")
      anagram2 = Anagram.create(word: "testx")

      expect(anagram1).to be_valid
      expect(anagram2).to_not be_valid
    end
  end
end
