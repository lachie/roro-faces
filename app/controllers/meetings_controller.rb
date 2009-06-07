class MeetingsController < ApplicationController
  before_filter :load_group

  def index
    respond_to do |wants|
      wants.html { redirect_to root_url }
      wants.atom do
        @meetups = Meeting.feed_list
      end
    end
  end
  
  def show
    @meeting = @group.meetings.by_date(params[:id]).first
  end
  
  protected
  def load_group
    @group = Group.find_by_short_name(params[:group_id])
  end
end
