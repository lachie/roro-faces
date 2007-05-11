require 'rubygems'
require 'hpricot'
require 'uri'
require 'open-uri'

class Favicon
  class << self
    def url_from_file(url,file)
      href = (Hpricot(file) % "link[@rel~='icon']")['href'] rescue '/favicon.ico'
      URI.join(url,href).to_s
    end
    
    def url(url)
      url_from_file(url,URI.read(url))
    end
      
  end
end