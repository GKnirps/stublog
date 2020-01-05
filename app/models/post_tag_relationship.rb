class PostTagRelationship < ActiveRecord::Base
  belongs_to :blogpost
  belongs_to :tag
end
