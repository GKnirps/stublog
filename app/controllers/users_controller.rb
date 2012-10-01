class UsersController < ApplicationController
  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
  end

  def create
  	@user = User.new(params[:user])
	if @user.save then
		flash[:succes] = "Welcome to Stranger Than Usual"
		redirect_to @user
	else
		render 'new'
	end
  end

  def edit
  	
  end

  def update
  	if @user.update_attributes(params[:user]) then
		flash[:succes] = "Profile Information updated."
		redirect_to @user
	else
		render 'edit'
	end
  end

  def index
  	@users = User.paginate(:page => params[:page])
  end

  def destroy
  	u = User.find(params[:id])
	u.destroy
	flash[:succes] = "User #{u.name} deleted"
	redirect_to users_url
  end

  def confirm_destroy
  	@user = User.find(params[:id])
  end
end
