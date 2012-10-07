class Blogpost < ActiveRecord::Base
  attr_accessible :caption, :content

  #exactly one user created a one blogpost
  belongs_to :user
  #can has many tags
  has_many :post_tag_relationships, dependent: :destroy
  has_many :tags, through: :post_tag_relationships

  #content and database length maximum due to database format
  validates :content, presence: true, length: {maximum: 65000}
  validates :caption, presence: true, length: {maximum: 250}
  validates :user_id, presence: true

  #order the blogposts by date, newest first
  default_scope order: 'blogposts.created_at DESC'

  def add_tag!(tag)
  	t = Tag.find_by_name(tag.downcase)
	if not t then
		t = Tag.create(name: tag.downcase)
	end
	if not post_tag_relationships.find_by_tag_id(t.id) then
		post_tag_relationships.create!(tag_id: t.id)
	end
  end
  def add_taglist!(taglist)
	taglist.split(/\s*,\s*/).each do |tag|
		add_tag!(tag)
	end
  end
  def destroy_tag_relationship!(tag)
	t = Tag.find_by_name(tag.downcase)
	if t and rel = post_tag_relationships.find_by_tag_id(t.id) then
		rel.destroy
	end
  end
end
