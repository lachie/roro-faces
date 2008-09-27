class PresoCommentsController < ApplicationController
  before_filter :load_parents
  
  def create
    @preso.preso_comments.create!(params[:preso_comment].update(:user_id => current_user.id))
    redirect_to group_meeting_preso_path(@group,@meeting,@preso)
  end
  
  def update
  end
  
  protected
  def load_parents
    @group   = Group.find_by_short_name(params[:group_id])
    @meeting = @group.meetings.find_by_date(params[:meeting_id])
    @preso = @meeting.presos.find(params[:preso_id])
  end
end