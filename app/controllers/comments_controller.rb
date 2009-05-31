class CommentsController < ApplicationController
  before_filter :load_parents
  
  def create
    @preso.comments.create!(params[:comment].update(:user_id => current_user.id))
    redirect_to group_meeting_preso_path(@group,@meeting,@preso)
  end
  
  protected
  def load_parents
    @group   = Group.find_by_short_name(params[:group_id])
    @meeting = @group.meetings.by_date(params[:meeting_id]).first
    @preso = @meeting.presos.find(params[:preso_id])
  end
end
