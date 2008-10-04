
class Admin::MeetingsController < Admin::ApplicationController
  before_filter :load_parents
  before_filter :load_meeting, :only => [:show,:update]
  
  def show
  end
  
  def create
    @meeting = @group.meetings.create!(params[:meeting])
    redirect_to admin_group_meetings_path(@group,@meeting)
  end
  
  def update
    @meeting.update_attributes!(params[:meeting])
    redirect_to polymorphic_path([:admin,@group,@meeting])
  end
  
  protected
  def load_meeting
    @meeting = @group.meetings.by_date(params[:id]).first
  end
  def load_parents
    @group = Group.find_by_short_name(params[:group_id])
  end
end