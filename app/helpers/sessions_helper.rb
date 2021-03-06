module SessionsHelper
	def sign_in(user, permanent)
    user.reset_remember_token!
		if permanent then
			cookies.permanent[:remember_token] = {value: user.remember_token, httponly: true}
		else
			expire_time = 1.hour.from_now
			expire_time = 1.minute.from_now if Rails.env.development?
			cookies[:remember_token] = {value: user.remember_token, expires: expire_time, httponly: true}
		end
		self.current_user = user
	end
	
	def sign_out
    self.current_user.reset_remember_token!
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
		@current_user ||=User.where(remember_token: cookies[:remember_token]).to_a[0]
	end
	def current_user?(user)
		self.current_user == user
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

	#if the user
	def author_user
		redirect_to root_path, notice: "You are no author in this blog." unless current_user.author?
  	end

	def admin_user
		redirect_to root_path, notice: "Only administrators can do that." unless current_user.admin?
	end
	
	#author OR admin
	def author_admin_user
		redirect_to root_path, notice: "You are trespassing." unless current_user.admin? or current_user.author?
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
