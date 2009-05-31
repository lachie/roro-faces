class FrontController < ApplicationController
  def index
    @tweets = FeedItem.twitter.all(:limit => 10, :order => 'updated_at desc,uuid desc')

    @meetups = []
    @meetups += @next_meetups.map {|m| ['meetup',m]}
    @meetups += Meeting.last_analogue_blog.map {|m| ['blog',m]}

    @meetups.sort! {|a,b| a[1].updated_at <=> b[1].updated_at}
  end
end
