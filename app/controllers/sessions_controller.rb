class SessionsController < ApplicationController
	def new
	end

	def create
		user = User.find_by_email(params[:email].downcase)
		if user and user.authenticate(params[:password]) then
			sign_in user, params[:permanent]
			redirect_back_or user
		else
			flash.now[:error] = "Invalid login"
			render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to root_url
	end
end
