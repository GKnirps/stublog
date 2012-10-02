class HostedFile < ActiveRecord::Base
  attr_accessible :description, :name, :public, :user_id
end
