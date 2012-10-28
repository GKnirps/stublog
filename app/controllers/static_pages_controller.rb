class StaticPagesController < ApplicationController
  def home
  	@blogposts = Blogpost.limit(10)
	@quote_of_the_day = QuoteOfTheDay.published.first
  end

  def contact
  end
end
