class MeetingsController < ApplicationController
  before_filter :load_group
  
  def show
    @meeting = @group.meetings.by_date(params[:id]).first
  end
  
  protected
  def load_group
    @group = Group.find_by_short_name(params[:group_id])
  end
end
