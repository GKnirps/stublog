class HostedFilesController < ApplicationController
  before_filter :signed_in_user, only: [:update, :edit, :destroy, :new, :create, :confirm_destroy]
  before_filter :maybe_signed_in_user, only: [:download, :show]
  before_filter :author_user, only: [:new, :create]
  before_filter :can_modify, only: [:edit, :update, :destroy, :confirm_destroy]
  #TODO: allowed to modify?

  def new
  	@hosted_file = current_user.hosted_files.new()
  end

  def create
	@hosted_file = current_user.hosted_files.new(description: params[:description], :public => params[:public])
	unless params[:file]
		flash[:error] = "You must specify a file."
		render 'new'
		return
	end
	@hosted_file.name = params[:file].original_filename
	if not (/^(\.?[a-zA-Z0-9_-]+)\.?$/).match @hosted_file.name then
		flash[:error] = "The filename contains illegal characters, allowed are only a-z, A-Z, 0-9, _, - and single dots."
		render 'new'
		return
	end
	@hosted_file.mime_type = params[:file].content_type
	if @hosted_file.save then
		if save_upload(params[:file]) then
			flash[:success] = "The file has been uploaded."
			redirect_to @hosted_file
		else
			@hosted_file.destroy
			flash[:error] = "Was not able to save file."
			render 'new'
		end
	else
		render 'new'
	end
  end

  def edit
  	@hosted_file = HostedFile.find(params[:id])
  end

  def update
	if @hosted_file.update_attributes(params[:hosted_file]) then
		flash[:success] = "File attributes updated"
		redirect_to @hosted_file
	else
		render 'edit'
	end
  end

  def index
  	@hosted_files = HostedFile.paginate(page: params[:page])
  end

  def show
  	@hosted_file = HostedFile.find(params[:id])
  end

  def download
	# if we do not use disposition: inline, the default is disposition: attachment, which will make the browser show the download dialog. When we want to show the download dialog, we should set this at the a tag for the download. Problem: Firefox preferes the Content-Disposition header to the a tag (that is bad for us), Chrome does not... We need a solution for that (preferably by not setting the header at all, which does not seem to be supported...
	send_file Rails.root.join(file_directory, @hosted_file.name), type: @hosted_file.mime_type, x_sendfile: true, disposition: 'inline'
  end

  def confirm_destroy
  end

  def destroy
  	delete_file(@hosted_file.name)
  	HostedFile.find(params[:id]).destroy
	flash[:success] = "File deleted"
	redirect_to hosted_files_path
  end

  private
  #redirects to log in page if user needs to be signed in to see a file but is not
  def maybe_signed_in_user
  	@hosted_file = HostedFile.find(params[:id])
	unless signed_in? or @hosted_file.public
		store_location
		redirect_to signin_url, notice: "You have to be logged in to do this"
	end
  end

  #is the user allowed to modify this file?
  def can_modify
	@hosted_file = HostedFile.find(params[:id])
	unless current_user.admin? or @hosted_file.user_id == current_user.id
		redirect_to root_path, notice: 'You are not allowed to modify this file!'
	end
  end

end
