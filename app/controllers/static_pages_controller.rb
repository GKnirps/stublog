class StaticPagesController < ApplicationController
  def home
  	@blogposts = Blogpost.limit(10)
  end

  def contact
  end
end
