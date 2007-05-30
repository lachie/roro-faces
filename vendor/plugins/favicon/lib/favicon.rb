require 'rubygems'
require 'hpricot'
require 'uri'
require 'open-uri'

class Favicon
  class << self
    def url_from_file(url,file)
      href = (Hpricot(file) % "link[@rel~='icon']")['href'] rescue nil
      return nil unless href
      URI.join(url,href).to_s
    end
    
    def from_url(url)
      url = "http://#{url}" unless url[%r{^http://}]
      open(url) {|f| url_from_file(url,f)}
    end
      
  end
end