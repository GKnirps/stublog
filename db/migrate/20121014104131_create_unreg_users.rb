class CreateUnregUsers < ActiveRecord::Migration
  def change
    create_table :unreg_users do |t|
      t.string :name

      t.timestamps
    end
  end
end
