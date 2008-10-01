class FeedItem < ActiveRecord::Base
  belongs_to :feed
  
  before_save :denormalize
  
  named_scope :twitter, :conditions => {:nominal_type => 'twitter'}
  
  protected
  def denormalize
    self.nominal_type = feed.nominal_type
  end
end
