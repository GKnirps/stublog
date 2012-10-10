class CategoriesController < ApplicationController
  before_filter :signed_in_user, only: [:new, :create, :destroy, :confirm_destroy, :edit, :update]
  before_filter :admin_user, only: [:new, :create, :destroy, :confirm_destroy, :edit, :update]
  def show
  	@category = Category.find(params[:id])
	@blogposts = @category.blogposts.paginate(page: params[:page])
  end

  def index
  	@categories = Category.paginate(page: params[:page])
  end

  def new
  	@category = Category.new
  end

  def create
  	@category = Category.new(params[:category])
	if @category.save then
		flash[:success] = "New category created"
		redirect_to @category
	else
		render 'new'
	end

  end

  def edit
  	@category = Category.find(params[:id])
  end

  def update
  	@category = Category.find(params[:id])
  	if @category.update_attributes(params[:category]) then
		flash[:success] = "Category updated"
		redirect_to @category
	else
		render 'edit'
  	end
  end

  def confirm_destroy
  	@category = Category.find(params[:id])
  end

  def destroy
  	c = Category.find(params[:id])
	c.destroy
	flash[:success] = "Category #{c.name} deleted"
	redirect_to categories_url
  end
end
