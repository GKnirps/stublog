class UnregUser < ActiveRecord::Base
  attr_accessible :name

  #unregistred users can write comments (as of now, comments are destroyed if user is deleted)
  has_many :comments, as: :author, dependent: :destroy

  validates :name, presence: true, length: {maximum: 42}

end
