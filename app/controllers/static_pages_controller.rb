class StaticPagesController < ApplicationController
  def home
  	@blogposts = Blogpost.limit(10)
	@quote_of_the_day = QuoteOfTheDay.first
  end

  def contact
  end
end
