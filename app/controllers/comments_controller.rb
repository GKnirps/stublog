class CommentsController < ApplicationController
before_filter :can_modify, only: [:edit, :update, :destroy, :confirm_destroy]
before_filter :find_author_and_predecessor, only: [:create, :answer]

def create
	@blogpost = Blogpost.find(params[:blogpost_id])
	#if the author isn't in the db yet, save him (ugly, TODO: find better solution)
	#TODO: this can lead to multiple unregistered users
	@author.save unless @author.id?
	
	@comment = @author.comments.new(params[:comment])

	
	@comment.predecessor = @predecessor
	if (@author.valid? or @author.id?) and @comment.save then
		@author.errors.clear
		#success
		flash[:success] = "You posted a new comment"
		redirect_to @blogpost
	else
		@comments = @blogpost.comments.all
		render 'blogposts/show'
	end
end

#answer to another comment
def answer
	@blogpost = Blogpost.find(params[:blogpost_id])
	@predecessor = Comment.find(params[:id])
	@comment = @predecessor.comments.new

	@comments = @blogpost.comments.all
	render 'blogposts/show'
end


def find_author_and_predecessor
	@blogpost = Blogpost.find(params[:blogpost_id])
	#by default, the predecessor is the blogpost. If it is not, there is a param named :pred_id
	if not params[:pred_id] then
		@predecessor = @blogpost
	else
		@predecessor = Comment.find(params[:pred_id])
	end
	if signed_in?
		@author = current_user
	else
		@author = UnregUser.new(name: params[:name])
	end
end

end
