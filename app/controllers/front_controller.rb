class FrontController < ApplicationController
  def index
    @tweets = FeedItem.twitter.all(:limit => 10, :order => 'updated_at desc,uuid desc')
  end
end
