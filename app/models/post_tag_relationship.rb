class PostTagRelationship < ActiveRecord::Base
  attr_accessible :blogpost_id, :tag_id
  
  belongs_to :blogpost
  belongs_to :tag
end
