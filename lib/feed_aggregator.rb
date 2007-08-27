# length(u.site_url) is null or length(u.site_url)=0
require 'pp'
require 'open-uri'
require 'hpricot'
require 'feed-normalizer'

class FeedAggregator
  class << self
    def feed_link_from_url(url)
      url = url[/^https?:\/\//] ? url : "http://#{url}"
      doc = Hpricot(open(url))
      
      feed_link = doc.search("//html/head/link[@type='application/rss+xml']")[0] rescue nil
  		feed_link ||= doc.search("//html/head/link[@type='application/atom+xml']")[0] rescue nil
  		
  		feed_link['href']
		end
		
		def feed(url)
		  FeedNormalizer::FeedNormalizer.parse open(url)
	  end
	   
  end
end