class User < ActiveRecord::Base
	attr_accessible :email, :name, :password, :password_confirmation
	#
	has_secure_password

	#User name has to be present, should be unique (though it is not fatal if it is not
	validates :name, presence: true length: {maximum: 42}, uniqueness: {case_sensitive: false}

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	#Email is used to authenticate, so it has to be unique, and should at least be shaped like an email address
	validates :email, presence: true, format: {with => VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
	
	#save emails lowercase 
	before_save {|user| user.email = email.downcase}

	validates :password, presence: true, length: {minimum: 6}
	validates :password_confirmation, presence: true
end
