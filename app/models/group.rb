class Group < ActiveRecord::Base
  has_many :affiliations
  has_many :users, :through => :affiliations
  has_many :meetings
  
  has_many :feeds, :as => :feedable
  
  after_create :create_feed
  
  named_scope :front_page_order, :order => 'once_off asc,name asc'
  
  def twitter_feed
    feeds.twitter.first
  end
  
  def to_param
    short_name
  end
  
  def create_feed
    return if twitter_hashtag.blank?
    
    feeds.twitter.each {|f| f.destroy}
    
    feeds.create :feed_url => "http://search.twitter.com/search.atom?q=%23#{twitter_hashtag}", :nominal_type => 'twitter'
  end
end