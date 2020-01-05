class CategoriesController < ApplicationController
  before_filter :signed_in_user, only: [:new, :create, :destroy, :confirm_destroy, :edit, :update]
  before_filter :admin_user, only: [:new, :create, :destroy, :confirm_destroy, :edit, :update]
  def show
  	@category = Category.where(id: params[:id]).to_a[0]
	@blogposts = @category.blogposts.paginate(page: params[:page])
  end

  def index
  	@categories = Category.paginate(page: params[:page])
  end

  def new
  	@category = Category.new
  end

  def create
  	@category = Category.new(category_params)
	if @category.save then
		flash[:success] = "New category created"
		redirect_to @category
	else
		render 'new'
	end

  end

  def edit
  	@category = Category.where(id: params[:id]).to_a[0]
  end

  def update
  	@category = Category.where(id: params[:id]).to_a[0]
  	if @category.update_attributes(category_params) then
		flash[:success] = "Category updated"
		redirect_to @category
	else
		render 'edit'
  	end
  end

  def confirm_destroy
  	@category = Category.where(id: params[:id]).to_a[0]
  end

  def destroy
  	c = Category.where(id: params[:id]).to_a[0]
	c.destroy
	flash[:success] = "Category #{c.name} deleted"
	redirect_to categories_url
  end
  
  private
  def category_params
    params.require(:category).permit(:name, :description)
  end
end
