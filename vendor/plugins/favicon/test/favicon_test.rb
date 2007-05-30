require 'test/unit'
require File.dirname(__FILE__)+'/../lib/favicon'

class FaviconTest < Test::Unit::TestCase
  def data(name)
    File.dirname(__FILE__)+"/data/#{name}"
  end
        
  def test_should_find_favicon
    assert_equal("http://wikipedia.com/favicon.ico", Favicon.url_from_file("http://wikipedia.com/Favicon",open(data('wikipedia.html'))))
  end
  
  def test_should_return_fallback_favicon
    assert_equal(nil, Favicon.url_from_file("http://wikipedia.com/Favicon",open(data('nofavicon.html'))))
  end
  
  def test_should_find_favicon_tricky
      assert_equal("http://assets0.twitter.com/images/favicon.ico?1180506828", 
        Favicon.url_from_file("http://twitter.com",open(data('twitter.html'))))
  end
end
