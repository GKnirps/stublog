class TagsController < ApplicationController
	def show
		@tag = Tags.find(params[:id])
	end
	def index
		@tags = Tags.all
	end
end
