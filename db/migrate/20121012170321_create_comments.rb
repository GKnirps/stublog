class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :caption
      t.string :content
      t.references :predecessor, polymorphic: true
      t.references :author, polymorphic: true
      t.timestamps
    end
    add_index :comments, :predecessor_id
    add_index :comments, :author_id
  end
end
