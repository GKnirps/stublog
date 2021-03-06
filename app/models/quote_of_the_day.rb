class QuoteOfTheDay < ActiveRecord::Base
  validates :content, presence: true, length: {maximum: 65000}
  validates :sourcedesc, length: {maximum: 250}

  URL_FORMAT = /\A\z$|^https?:\/\/.*/
  validates :sourceurl, length: {maximum: 250}, format: {with: URL_FORMAT}

  default_scope {order(updated_at: :desc)}
  
  #Scope for all published quotes
  scope :published, -> { where published: true  }
  scope :unpublished, -> { where published: false }

  def self.current_quote
    self.published.first 
  end

  def self.publish_next!
	self.unpublished.last.update_attribute(:published, true)
  end

  #randomly decides if a non-published quote is published (depending on the number of non-published quotes)
  def self.publish?
	publish_probability > Random.rand
  end
  
  def self.publish_probability
	prob(self.where(published:false).count, {})
  end

  private
  #probability of publication dependent on number of items in the buffer
  #this is based on a sigmoidal function, but 0 if there are no items in the buffer
  #options:       :offset the number of items for which the probability is 0.5 (default: 4)
  #               :stretch factor by which the curve is stretched (default: 1.5)
  def self.prob(n, options = {})
        if n<=0 then
                return 0
	end
        offset = options.fetch(:offset, 4)
        stretch = options.fetch(:stretch, 1.5)
        1.0/(1+Math.exp(-(n.to_f-offset)/stretch))
  end

end
