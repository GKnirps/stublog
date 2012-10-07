class Category < ActiveRecord::Base
  attr_accessible :name

  #each category can has multiple posts
  has_many :blogposts

  validates :name, presence: true, length: {maximum: 42}, uniqueness: {case_sensitive: true}

  #delete category references in all posts with this category
  before_destroy :delete_category_references

  #order categories by name
  default_scope order: 'categories.name'

  private
  def delete_category_references
	self.blogposts.each do |p|
		p.update_attribute(:category_id, nil)
	end
  end
end
