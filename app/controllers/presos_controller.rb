class PresosController < ApplicationController
  before_filter :load_meeting
  
  
  
  def index
    @meeting.presos
  end
  
  def show
    @preso = Preso.find(params[:id])
    @meeting ||= @preso.meeting
    @group   ||= @meeting.group
    
    @other_presos = @meeting.presos - [@preso]
  end
  
  def edit
    @preso = Preso.find(params[:id])
  end
  
  def new
    @preso = @meeting.presos.build
  end
  
  def create
    @preso = @meeting.presos.create!(params[:preso].update(:user_id => current_user.id))
    redirect_to group_meeting_preso_path(@group,@meeting,@preso)
  end
  
  def update
    @preso = Preso.find(params[:id])
    @preso.update_attributes(params[:preso]) or raise RecordNotSaved
    redirect_to group_meeting_preso_path(@group,@meeting,@preso)
  end
  
  protected
  def load_meeting
    @group   = Group.find_by_short_name(params[:group_id])
    @meeting = @group.meetings.find_by_date(params[:meeting_id])
  end

end