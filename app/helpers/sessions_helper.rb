module SessionsHelper
	def sign_in(user, permanent)
		if permanent then
			cookies.permanent[:remember_token] = user.remember_token
		else
			expire_time = 1.hour.from_now
			expire_time = 1.minute.from_now if Rails.env.development?
			cookies[:remember_token] = {value: user.remember_token, expires: expire_time}
		end
		self.current_user = user
	end
	
	def sign_out
		self.current_user = nil
		cookies.delete(:remember_token)
	end
	def signed_in?
		not self.current_user.nil?
	end
	def current_user=(u)
		@current_user = u
	end
	def current_user
		@current_user ||=User.find_by_remember_token(cookies[:remember_token])
	end
	def current_user?(user)
		@current_user = u
	end

	#if the user needs to be logged in (but is not), this function redirects to the
	#signin page but saves the current location, so after the login the user can be
	#redirected
	def signed_in_user
		unless signed_in?
			store_location
			redirect_to signin_url, notice: "You have to be logged in to do this"
		end
	end

	#redirect to the stored location (if there is one)
	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
		session.delete(:return_to)
	end

	def store_location
		session[:return_to] = request.url
	end
end
