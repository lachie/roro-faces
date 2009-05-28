class Admin::PresosController < Admin::ApplicationController
  before_filter :load_models
  before_filter :load_preso, :except => [:create]
  
  def show
  end
  
  def create
    @preso = @meeting.presos.create!(params[:preso])
    redirect_to polymorphic_path([:admin,@group,@meeting,@preso])
  end
  
  def update
    @preso.update_attributes!(params[:preso])
    redirect_to polymorphic_path([:admin,@group,@meeting,@preso])
  end
  
  protected
  def load_preso
    @preso = Preso.find(params[:id])
  end
  def load_models
    @group = Group.find_by_short_name(params[:group_id])
    @meeting = @group.meetings.by_date(params[:meeting_id]).first
  end
end
