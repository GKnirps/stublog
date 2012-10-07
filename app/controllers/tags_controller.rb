class TagsController < ApplicationController
	def show
		@tag = Tag.find(params[:id])
  		@blogposts = @tag.blogposts.paginate(:page => params[:page])
	end
	def index
		@tags = Tag.order("name")
	end
end
