class MeetingsController < ApplicationController
  before_filter :load_group
  
  def show
    @meeting = @group.meetings.find_by_date(params[:id])
  end
  
  protected
  def load_group
    @group = Group.find_by_short_name(params[:group_id])
  end
end
