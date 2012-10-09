class BlogpostsController < ApplicationController
  before_filter :signed_in_user, only: [:new, :create, :destroy, :confirm_destroy, :edit, :update]
  before_filter :author_user, only: [:new, :create]
  before_filter :can_modify, only: [:destroy, :confirm_destroy, :edit, :update]

  def confirm_destroy
  	@blogpost = Blogpost.find(params[:id])
  end

  def new
  	@blogpost = current_user.blogposts.new
	@categories = Category.all
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
		@blogpost.add_taglist!(params[:tags])
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
	@categories = Category.all
	@category_selection_params = {prompt: true}
	@category_selection_params = {selected: @blogpost.category} if @blogpost.category
	tags = []
	@blogpost.tags.each do |tag|
		tags.push tag.name
	end
	@tags = tags.join(", ")
  end

  def update
  	if @blogpost.update_attributes(params[:blogpost]) then
		newtags = params[:tags].split(/\s*,\s*/)
		oldtags = @blogpost.tags.map {|t| t.name}
		
		#add new tags
		(newtags-oldtags).each do |tag|
			@blogpost.add_tag!(tag)
		end
		#delete tags that are no longer valid
		(oldtags-newtags).each do |tag|
			@blogpost.destroy_tag_relationship!(tag)
		end

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
