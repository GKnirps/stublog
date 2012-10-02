class User < ActiveRecord::Base
	attr_accessible :email, :name, :password, :password_confirmation
	#generate secure password hash automatically
	has_secure_password

	#Each user can have any number of blogposts
	#TODO: as of now, the blogposts are removed if the user is deleted (might want to change that)
	has_many :blogposts, dependent: :destroy
	has_many :hosted_files

	#User name has to be present, should be unique (though it is not fatal if it is not
	validates :name, presence: true, length: {maximum: 42}, uniqueness: {case_sensitive: false}

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	#Email is used to authenticate, so it has to be unique, and should at least be shaped like an email address
	validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
	
	#save emails lowercase 
	before_save {|user| user.email = email.downcase}
	#create remember token for sessions
	before_save :create_remember_token

	validates :password, presence: true, length: {minimum: 6}
	validates :password_confirmation, presence: true

	private
	def create_remember_token
		self.remember_token = SecureRandom.urlsafe_base64
	end
end
