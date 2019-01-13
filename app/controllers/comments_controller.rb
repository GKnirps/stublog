class CommentsController < ApplicationController
before_filter :can_modify, only: [:edit, :update, :destroy, :confirm_destroy]
before_filter :find_author_and_predecessor, only: [:create, :answer]

def create
	@blogpost = Blogpost.find(params[:blogpost_id])

  if (not params[:precontent].nil? and not params[:precontent].empty?) or
     (not params[:postcontent].nil? and not params[:postcontent].empty?) then
    flash[:error] = "You are not allowed to post comments this way."
    redirect_to @blogpost
    return
  end


	#if the author isn't in the db yet, save him (ugly, TODO: find better solution)
	#TODO: this can lead to multiple unregistered users
	@author.save unless @author.id?
	
	@comment = @author.comments.new(params[:comment])

  if @predecessor then
	    @comment.predecessor_id = @predecessor.id
  end
  @comment.blogpost = @blogpost
	if (@author.valid? or @author.id?) and @comment.save then
		@author.errors.clear
		#success
		flash[:success] = "You posted a new comment"
		redirect_to @blogpost
	else
		@comments = @blogpost.comment_tree
		render 'blogposts/show'
	end
end

#answer to another comment
def answer
	@blogpost = Blogpost.find(params[:blogpost_id])
	@predecessor = Comment.find(params[:id])
	@comment = Comment.new
  @comment.predecessor_id = @predecessor.id
  @comment.blogpost_id = @blogpost.id

	@comments = @blogpost.comment_tree
	render 'blogposts/show'
end


def find_author_and_predecessor
  # we always need the author of the comment. When the comment has a predecessor, we also need the predecessor.
	@blogpost = Blogpost.find(params[:blogpost_id])
	if params[:pred_id] then
		@predecessor = Comment.find(params[:pred_id])
	end
	if signed_in?
		@author = current_user
	else
		@author = UnregUser.new(name: params[:name])
	end
end

end
