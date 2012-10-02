class BlogpostsController < ApplicationController
  before_filter :signed_in_user, only: [:new, :create, :destroy, :confirm_destroy]

  def confirm_destroy
  end

  def new
  end

  def show
  	@blogpost = Blogpost.find(params[:id])
  end

  def index
  	@blogposts = Blogpost.paginate(:page => params[:page])
  end

  def create
  end

  def destroy
  end
end
