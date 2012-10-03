class CreateHostedFiles < ActiveRecord::Migration
  def change
    create_table :hosted_files do |t|
      t.string :name
      t.text :description
      t.integer :user_id
      t.boolean :public

      t.timestamps
    end
    add_index :hosted_files, :name, unique: true
    add_index :hosted_files, :user_id
  end
end
