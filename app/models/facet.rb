class Facet < ActiveRecord::Base
  belongs_to :user
  belongs_to :facet_kind
  
  # validates_presence_of :name
  
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
    unless @info
      info = begin
                i = YAML.load(read_attribute(:info))
                raise unless Hash === i
                i
              rescue
                logger.error "failed to load info ($!)"
                {}
              end

      @info = facet_kind.parameters.merge(info || {})
    end
    
    @info
  end
  
  def info=(hash)
    unless Hash === hash
      write_attribute(:info, nil)
      @info = {}
    else
      @info = hash
      write_attribute(:info, hash.to_yaml)
    end
  end
  
  def favicon_url
    f = facet_kind.favicon_url
    f.blank? ? nil : f
  rescue
    nil
  end
end
