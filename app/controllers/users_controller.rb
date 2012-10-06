class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:update, :edit, :index, :destroy, :confirm_destroy]
  before_filter :correct_user, only: [:update, :edit, :destroy, :confirm_destroy]
  #before_filter :admin_user, only: [:destroy, :confirm_destroy]

  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
  end

  def create
  	@user = User.new(params[:user])
	if @user.save then
		flash[:success] = "Welcome to Stranger Than Usual"
		redirect_to @user
	else
		render 'new'
	end
  end

  def edit
  	
  end

  def update
  	if @user.update_attributes(params[:user]) then
		flash[:success] = "Profile Information updated."
		sign_in @user, false 
		redirect_to @user
	else
		render 'edit'
	end
  end

  def index
  	per_page = 30
  	@users = User.paginate(page: params[:page], per_page: per_page)
	#if this is not page 1, do not count the users from one
	@count = 1
	if params[:page] then
		@count = per_page*(Integer(params[:page])-1)+1
	end
		
  end

  def destroy
  	u = User.find(params[:id])
	u.destroy
	flash[:success] = "User #{u.name} deleted"
	if current_user.admin? then
		redirect_to users_url
	else
		redirect_to root_path
	end
  end

  def confirm_destroy
  	@user = User.find(params[:id])
  end

  private

  #filter function for actions the user can only do with his own account
  #also returns true if the session's user is admin
  def correct_user
  	@user = User.find(params[:id])
	unless current_user?(@user) or current_user.admin?
		redirect_to root_path, notice: "You are not allowed to do that."
	end
  end
  def admin_user
	redirect_to root_path notice: "Only administrators can do that." unless current_user.admin?
  end
end
