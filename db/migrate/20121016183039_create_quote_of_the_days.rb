class CreateQuoteOfTheDays < ActiveRecord::Migration
  def change
    create_table :quote_of_the_days do |t|
      t.text :content
      t.string :sourcedesc
      t.string :sourceurl
      t.boolean :published

      t.timestamps
    end
    add_index :quote_of_the_days, :published
  end
end
