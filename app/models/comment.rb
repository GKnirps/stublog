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
end
