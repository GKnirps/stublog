class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name

      t.timestamps
    end
    add_index :categories, :name, unique: true
    add_column :blogposts, :category_id, :string
    add_index :blogposts, :category_id
  end
end
