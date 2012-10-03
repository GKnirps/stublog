class AddMimetypeToHostedFile < ActiveRecord::Migration
  def change
  	add_column :hosted_files, :mime_type, :string	
  end
end
