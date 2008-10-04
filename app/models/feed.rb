require 'pp'
require 'open-uri'


class Feed < ActiveRecord::Base
  has_many :feed_items, :dependent => :destroy
  
  belongs_to :feedable, :polymorphic => true
  
  named_scope :twitter, :conditions => {:nominal_type => 'twitter'}
  
  def parse
    return unless reparse?
    parse!
  end
  
  def parse!
    self.class.transaction do
      feed = FeedParser.parse(open(feed_url))
      
      raise "failed to read the feed" unless feed
      
      _read_feed(feed)
      
      unless feed.entries.blank?
        feed.entries.each {|item| _read_item(item)}
      end
    end
    
    true
  rescue
    raise $!
  end
    
  def reparse?
    fetched_at.blank? || Time.now - fetched_at > 60
  end
  
  private
  def _read_feed(feed)
    update_attributes!(
      :uuid       => feed['id'],
      :title      => feed.title,
      :fetched_at => Time.now
    )
  end
  
  def _read_item(item)
    iid = item['id']
    feed_item = feed_items.find_by_uuid(iid) || feed_items.build(:uuid => iid)
    
    return unless !feed_item.updated_at || item.updated_time < feed_item.updated_at
    
    feed_item.title = item.title
    feed_item.body  = item.content[0]['value']
    feed_item.url   = item.url
    
    feed_item.author_name  = item.author
    feed_item.author_url   = item.author_detail['href']
    feed_item.author_email = item.author_detail['email']
    
    feed_item.save!
  end
  
end
