require 'open-uri'
#require 'hpricot'
require 'feed-normalizer'
require 'yaml'
require 'fileutils'

class FacetKind < ActiveRecord::Base
  has_many :facets
  has_many :users, :through => :facets
  
  before_save :get_favicon
  
  validates_presence_of :name, :title, :site
    
  def self.find_for_select
    find(:all,:order => 'name').collect {|f| [f.name,f.id]}
  end
  
  def feeds
    return [] if feed.blank?
    facets.collect(&:feed)
  end
  
  def aggregated_feed
    
  end
  
  def aggregated_entries
    feeds.collect do |feed|
      f = FeedNormalizer::FeedNormalizer.parse(open(feed))
      f.entries
    end.flatten
  end
  
  def parameters
    unless @parameters
      @parameters = {}
      [site,feed,title].each {|s| extract_parameters(s,@parameters)}
    end  
    @parameters.dup
  end
  
  def merge_site(params)
    merge(site,params) unless site.blank?
  end
  
  def merge_title(params)
    merge(title,params) unless title.blank?
  end
  
  def merge_feed(params)
    merge(feed,params) unless feed.blank?
  end
  
  def merge(string,params)
    params = parameters.merge(params || {})
    string.gsub(/\$\{(\w+)\}/) { params[$1] }
  end
  
  
  
  protected
  PARAM_RE = /
    \$\{
    (\w+)
    \}
  /x
  
  def extract_parameters(string,store)
    return unless string
    string.scan(PARAM_RE) {|p| store[p.first] ||= nil }
  end
  
  def get_favicon
    self.favicon_url = Favicon.from_url(service_url)
  end
end
