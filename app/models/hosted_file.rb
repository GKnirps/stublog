class HostedFile < ActiveRecord::Base
	FILENAME_FORMAT = /[^\/]+/
	#the file must have a unique name (case sensitive) with maximum lenght (because of the database)
	#oh, in just in case: no slashes!
	validates :name, presence: true, uniqueness: {case_sensitive: true}, length: {maximum: 250}, format: {with: FILENAME_FORMAT}

	#each file belongs to a user
	belongs_to :user
	
	#mime type must not be emtpy
	validates :mime_type, presence: true

end
