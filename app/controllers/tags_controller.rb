class TagsController < ApplicationController
	def show
		@tag = Tag.where(id: params[:id]).to_a[0]
  		@blogposts = @tag.blogposts.paginate(:page => params[:page])
	end
	def index
		@tags = Tag.order("name")
	end
	def search
		@tags = ""
		@results = []
	end
	def find
		@tags = params[:tags]
		#TODO: use database operations to make this search faster (a LOT faster)
		tag_array = @tags.split(/\s*,\s*/)
		@results = Blogpost.all.delete_if {|p| !(tag_array-p.taglist).empty?}
		if @results.empty?
			flash.now[:notice] = "There are no posts with that combination of tags"
		end
		render 'search'
	end
end
