class BlogpostsController < ApplicationController
  before_filter :signed_in_user, only: [:new, :create, :destroy, :confirm_destroy]
  before_filter :author_user, only: [:new, :create]
  before_filter :can_modify, only: [:destroy, :confirm_destroy, :edit, :update]

  def confirm_destroy
  	@blogpost = Blogpost.find(params[:id])
  end

  def new
  	@blogpost = current_user.blogposts.new
  end

  def show
  	@blogpost = Blogpost.find(params[:id])
  end

  def index
  	@blogposts = Blogpost.paginate(:page => params[:page])
  end

  def create
  	@blogpost = current_user.blogposts.new(params[:blogpost])
	if @blogpost.save then
		flash[:success] = "New Blogpost published"
		redirect_to @blogpost
	else
		render 'new'
	end
  end

  def destroy
  	Blogpost.find(params[:id]).destroy
	flash[:success] = "Blogpost deleted"
	redirect_to root_path
  end

  def confirm_destroy
  end

  def edit
  	@blogpost = Blogpost.find(params[:id])
  end

  def update
  	if @blogpost.update_attributes(params[:blogpost]) then
		flash[:success] = "Blogpost updated."
		redirect_to @blogpost
	else
		render 'edit'
	end
  end

  private
  def can_modify
	@blogpost = Blogpost.find(params[:id])
	unless current_user.admin? or @blogpost.user_id == current_user.id
		redirect_to root_path, notice: 'You are not allowed to modify this post.'
	end
  end
end
