class ChangeUsers < ActiveRecord::Migration
  def change
  	change_column :users, :admin, :boolean, default: false
  	change_column :users, :author, :boolean, default: false
  end
end
