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
	#no preview needed, since there was no editing before
	@preview_desired = false
  end

  def show
  	@blogpost = Blogpost.find(params[:id])
	@comments = @blogpost.comments.all
	@comment = @blogpost.comments.new
	#when called from here: author of a new comment is unregistered if not logged in
	if not signed_in? then
		@author = UnregUser.new
	else
		@author = current_user
	end
	@predecessor = @blogpost
  end

  def index
  	@blogposts = Blogpost.paginate(:page => params[:page])
  end

  #RSS/atom feed
  def feed
	@title = "Stranger than usual"

	@blogposts = Blogpost.all
	@updated = @blogposts.first.created_at unless @blogposts.empty?

	respond_to do |format|
		format.atom { render layout: false }

		format.rss { render layout: false }
	end
  end

  def create
  	#does the user want a preview before posting?
  	@preview_desired = params[:commit] != "save"
	@categories = Category.all
	@tags = params[:tags]

  	@blogpost = current_user.blogposts.new(params[:blogpost])
	if !@preview_desired && @blogpost.save then
		@blogpost.add_taglist!(@tags)
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
