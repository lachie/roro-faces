class Admin::GroupsController < Admin::ApplicationController
  def index
    @groups    = Group.regular
    @once_offs = Group.once_off
  end
  
  def show
    @group = Group.find_by_short_name(params[:id])
  end

end
