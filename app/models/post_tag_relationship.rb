class PostTagRelationship < ActiveRecord::Base
  attr_accessible :blogpost_id, :tag_id
end
