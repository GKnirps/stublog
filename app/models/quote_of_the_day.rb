class QuoteOfTheDay < ActiveRecord::Base
  attr_accessible :content, :published, :sourcedesc, :sourceurl
 
  validates :content, presence: true, length: {maximum: 65000}
  validates :sourcedesc, length: {maximum: 250}

  URL_FORMAT = /^$|^https?:\/\/.*/
  validates :sourceurl, length: {maximum: 250}, format: {with: URL_FORMAT}

  default_scope where( published: true )
  default_scope order: "quote_of_the_days.created_at DESC"

  def self.current_quote
	self.first
  end

  def self.publish_next
	self.where(published: false).first.update_attribute(:published, true)
  end
end
