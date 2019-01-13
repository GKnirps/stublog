class Comment < ActiveRecord::Base
  attr_accessible :caption, :content, :predecessor_id
  
  validates :content, presence: true, length: {maximum: 65000}
  validates :caption, length: {maximum: 250}

  #belongs to an author (which can be a user or an unregistered user)
  belongs_to :author, polymorphic: true
  #belongs to a predecessor
  belongs_to :blogpost

  #order the comments by date, oldest first
  default_scope order: 'comments.created_at ASC'

  def comments
    @comment || []
  end

  def comments=(c)
    @comments = c
  end

end
