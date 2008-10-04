
class Admin::MeetingsController < Admin::ApplicationController
  before_filter :load_parents
  def show
    @meeting = @group.meetings.find_by_date(params[:id])
  end
  
  def create
    @meeting = @group.meetings.create!(params[:meeting])
    redirect_to admin_group_meetings_path(@group,@meeting)
  end
  
  protected
  def load_parents
    @group = Group.find_by_short_name(params[:group_id])
  end
end