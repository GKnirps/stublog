class StaticPagesController < ApplicationController
  def home
  	@blogposts = Blogpost.includes(:tags, :category, :user).limit(10)
	@quote_of_the_day = QuoteOfTheDay.current_quote
  end

  def contact
  end
end
