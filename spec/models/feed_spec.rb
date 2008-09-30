require File.dirname(__FILE__)+'/../spec_helper'

describe Feed do
  before do
    @f = Feed.new :feed_url => "#{RAILS_ROOT}/spec/fixtures/twitter.atom.xml"
    stub(@f).reparse? {true}
  end
  
  it "parses atom" do
    now = Time.now
    mock(Time).now.times(any_times) {now}
    
    @f.parse
    
    @f.fetched_at.should == now
  end
  
  it "has uuid" do
    @f.parse
    @f.uuid.should == 'tag:search.twitter.com,2005:search/ #webjam'
  end
  
  it "has title" do
    @f.parse
    @f.title.should == " #webjam - Twitter Search"
  end
  
  it "has 15 items" do
    @f.parse
    @f.should have(15).feed_items
  end
  
  it "still has 15 items" do
    @f.parse
    @f.should have(15).feed_items
    @f.parse
    @f.should have(15).feed_items
  end
  
  it "parses entry" do
    @f.parse!
    f = @f.feed_items.first
    f.uuid.should == 'tag:search.twitter.com,2005:938690866'
    f.author_name.should == 'renailemay (Renai LeMay)'
    f.author_url.should == 'http://twitter.com/renailemay'
    f.body.should == 'actually think I am still hungover from &lt;a href="/search?q=%23webjam"&gt;&lt;b&gt;#webjam&lt;/b&gt;&lt;/a&gt; .... man.'
  end
  
  # describe "#_read_item" do
  #   
  #   @f.send :_read_item
  # end
  
  describe "(live)" do
    before do
      @f = Feed.create :feed_url => "http://search.twitter.com/search.atom?q=%23webjam"
      
    end
    
    it "has 15 items" do
      @f.parse!
      @f.should have(15).feed_items
    end
  end
end