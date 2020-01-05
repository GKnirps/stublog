class Blogpost < ActiveRecord::Base
  #exactly one user created a one blogpost
  belongs_to :user
  #belongs to a category. If category is nil, the post should be marked as "uncategorized"
  belongs_to :category
  #can has many tags
  has_many :post_tag_relationships, dependent: :destroy
  has_many :tags, through: :post_tag_relationships

  #a blogpost may have multiple comments
  has_many :comments

  #content and database length maximum due to database format
  validates :content, presence: true, length: {maximum: 65000}
  validates :caption, presence: true, length: {maximum: 250}
  validates :user_id, presence: true

  #order the blogposts by date, newest first
  default_scope order: 'blogposts.created_at DESC'

  def add_tag!(tag)
    t = Tag.where(name: tag.downcase).to_a[0]
	if not t then
		t = Tag.create(name: tag.downcase)
	end
	if post_tag_relationships.where(tag_id: t.id).to_a.empty? then
		post_tag_relationships.create!(tag_id: t.id)
	end
  end
  def add_taglist!(taglist)
	taglist.split(/\s*,\s*/).each do |tag|
		add_tag!(tag)
	end
  end
  def destroy_tag_relationship!(tag)
	t = Tag.where(name: tag.downcase)
	if t and rel = post_tag_relationships.where(tag_id: t.id).to_a[0] then
		rel.destroy
	end
  end
  #return all tags of one post as array of strings
  def taglist
	self.tags.map {|t| t.name}
  end
  #return all tags of one post as comma separated list
  def tagstring
	self.taglist.join ', '
  end
  
  #returns the number of comments this blogpost has (directly or indirectly)
  def n_responses
    if Rails.configuration.comments_active then
	    self.comments.count
    else
      0
    end
  end

  def comment_tree
      if Rails.configuration.comments_active then
        self.comments
          .select {|c| c.predecessor_id == nil}
          .map{ |c| CommentNode.new(c, self.comments) }
      else
        []
      end
  end
end

class CommentNode
    attr_reader :caption, :content, :author, :created_at, :to_partial_path, :comments, :id

    def initialize(comment, all_comments)
        @caption = comment.caption
        @content = comment.content
        @author = comment.author
        @created_at = comment.created_at
        @partial_path = comment.to_partial_path
        @id = comment.id
        @comments = all_comments
          .select{ |c| c.predecessor_id == comment.id }
          .map{ |c| CommentNode.new(c, all_comments) }
    end
end
