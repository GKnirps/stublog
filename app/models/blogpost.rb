class Blogpost < ActiveRecord::Base
  attr_accessible :caption, :content

  #exactly one user created a one blogpost
  belongs_to :user

  #content and database length maximum due to database format
  validates :content, presence: true, length: {maximum: 65000}
  validates :caption, presence: true, length: {maximum: 250}
  validates :user_id, presence: true

  #order the blogposts by date, newest first
  default_scope order: 'blogposts.created_at DESC'


end
