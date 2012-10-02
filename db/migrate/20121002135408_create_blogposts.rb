class CreateBlogposts < ActiveRecord::Migration
  def change
    create_table :blogposts do |t|
      t.string :caption
      t.text :content
      t.integer :user_id

      t.timestamps
    end
    add_index :blogposts, [:user_id, :created_at]
  end
end
