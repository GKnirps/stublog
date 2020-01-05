class Tag < ActiveRecord::Base
  has_many :post_tag_relationships, dependent: :destroy
  has_many :blogposts, through: :post_tag_relationships

  validates :name, presence: true, length: {maximum: 42}, uniqueness: {case_sensitive: false}

  before_save {|tag| tag.name = name.downcase}
end
