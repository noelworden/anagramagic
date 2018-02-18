class AddProperNounToAnagrams < ActiveRecord::Migration[5.0]
  def change
    add_column :anagrams, :proper_noun, :boolean, :default => false
  end
end
