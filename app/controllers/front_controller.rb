class FrontController < ApplicationController
  def index
    @meetups = Meeting.next.all(:include => :group)
    @groups  = Group.regular.others(@meetups.map {|m| m.group_id})

    @tweets = FeedItem.twitter.all(:limit => 10, :order => 'updated_at desc,uuid desc')
    @user = User.front_page_random.first
  end
end
