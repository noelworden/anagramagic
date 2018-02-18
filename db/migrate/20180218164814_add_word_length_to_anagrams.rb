class AddWordLengthToAnagrams < ActiveRecord::Migration[5.0]
  def change
    add_column :anagrams, :word_length, :integer
  end
end
