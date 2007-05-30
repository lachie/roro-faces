class Facet < ActiveRecord::Base
  belongs_to :user
  belongs_to :facet_kind
  
  # validates_presence_of :name
  
  
  serialize :info, Hash
  
  SCHEME_RE = /^\w+:\/\//
  
  def link
    unless @link
      @link = facet_kind.merge_site(info)
      @link = @link[SCHEME_RE] ? @link : "http://#{@link}" unless @link.blank?
    end
    
    @link
  end
  
  def link_text
    @link_text ||= facet_kind.merge_title(info)
  end
  
  def feed
    @feed ||= facet_kind.merge_feed(info)
  end
  
  #link = self[:link]
  #return if link.blank?
  #
  
  def info
    facet_kind.parameters.merge(read_attribute(:info) || {})
  end
  
  def favicon_url
    f = facet_kind.favicon_url
    f.blank? ? nil : f
  rescue
    nil
  end
end
