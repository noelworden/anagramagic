class CreateAnagrams < ActiveRecord::Migration[5.0]
  def change
    create_table :anagrams do |t|
      t.string  :word
      t.integer :letter_count

      t.timestamps
    end
  end
end
