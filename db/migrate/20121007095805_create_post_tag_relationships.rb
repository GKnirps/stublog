class CreatePostTagRelationships < ActiveRecord::Migration
  def change
    create_table :post_tag_relationships do |t|
      t.integer :blogpost_id
      t.integer :tag_id

      t.timestamps
    end
    add_index :post_tag_relationships, :blogpost_id
    add_index :post_tag_relationships, :tag_id
    add_index :post_tag_relationships, [:blogpost_id, :tag_id], unique: true
  end
end
