class HostedFile < ActiveRecord::Base
	attr_accessible :description, :name, :public

	#the file must have a unique name (case sensitive) with maximum lenght (because of the database
	validates :name, presence: true, uniqueness: {case_sensitive: true}, lenght: {maximum: 250}
	
	#each file belongs to a user
	belongs_to :user
end
