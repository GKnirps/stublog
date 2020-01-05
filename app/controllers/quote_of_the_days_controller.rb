class QuoteOfTheDaysController < ApplicationController
  before_filter :signed_in_user, only: [:new, :create, :edit, :update, :confirm_destroy, :destroy]
  before_filter :author_user, only: [:new, :create]
  before_filter :author_admin_user, only: [:edit, :update, :confirm_destroy, :destroy]
  before_filter :quote_exists, only: [:edit, :update, :confirm_destroy, :destroy]

  def index
    if signed_in? && (current_user.admin? || current_user.author?) then
			@quote_of_the_days = QuoteOfTheDay.unpublished + QuoteOfTheDay.published
    else
  		@quote_of_the_days = QuoteOfTheDay.published
    end
		@buffersize = QuoteOfTheDay.unpublished.count
		@prob = QuoteOfTheDay.publish_probability
		@author_user = signed_in? && current_user.author?
		@admin_user = signed_in? && current_user.admin?
  end

	def show
    if signed_in? && (current_user.admin? || current_user.author?) then
		  @quote_of_the_day = QuoteOfTheDay.where(id: params[:id]).to_a[0]
    else
      @quote_of_the_day = QuoteOfTheDay.published.where(id: params[:id]).to_a[0]
    end
		@author_user = signed_in? && current_user.author?
		@admin_user = signed_in? && current_user.admin?
	end

  def new
		@quote_of_the_day = QuoteOfTheDay.new 	
  end

  def create
  	@quote_of_the_day = QuoteOfTheDay.new(qotd_params)
	if @quote_of_the_day.save then
		flash[:success] = "New quote saved"
		redirect_to quote_of_the_days_path
	else
		render 'new'
	end
  end

  def edit
  	#Quote variable should be given by before_filter
  end

  def update
  	if @quote_of_the_day.update_attributes(qotd_params) then
		flash[:success] = "change saved"
		redirect_to quote_of_the_days_path
	else
		render 'edit'
	end
  end

  def confirm_destroy
  	#Quote variable should be given by before_filter
  end

  def destroy
  	@quote_of_the_day.destroy
	flash[:success] = "Quote deleted"
	redirect_to quote_of_the_days_path
  end

  def fortune
  	q = QuoteToFortune.new
	send_file q.fortune_archive_path, type: "application/x-gzip", x_sendfile: true, filename: "stublog.tar.gz"
  end

  private
  #filter if a quote with a give id exists
  def quote_exists
	@quote_of_the_day = QuoteOfTheDay.where(id: params[:id]).to_a[0]
	if not @quote_of_the_day then
		redirect_to quote_of_the_days_path, notice: "There is no quote with id #{params[:id]}"
	end
  end

  def qotd_params
      params.require(:quote_of_the_day).permit(:content, :published, :sourcedesc, :sourceurl)
  end
end
