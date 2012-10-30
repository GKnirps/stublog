class Comment < ActiveRecord::Base
  attr_accessible :caption, :content
  
  validates :content, presence: true, length: {maximum: 65000}
  validates :caption, length: {maximum: 250}

  #belongs to an author (which can be a user or an unregistered user)
  belongs_to :author, polymorphic: true
  #belongs to a predecessor (either a blogpost or another comment)
  belongs_to :predecessor, polymorphic: true
  has_many :comments, as: :predecessor

  #order the comments by date, oldest first
  default_scope order: 'comments.created_at ASC'

  #returns the number of comments this comment has (directly or indirectly)
  #due to the database structure, this may require a lot of db requests
  def n_responses
	sum = self.comments.count
	self.comments.each do |c|
		puts sum.class
		puts c.n_responses.class
		sum = sum + c.n_responses
	end
	sum
  end
end
