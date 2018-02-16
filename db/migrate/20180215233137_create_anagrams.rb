class CreateAnagrams < ActiveRecord::Migration[5.0]
  def change
    create_table :anagrams do |t|
      t.string  :word
      t.integer :count

      t.timestamps
    end
  end
end
