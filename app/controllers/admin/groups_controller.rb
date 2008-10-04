class Admin::GroupsController < ApplicationController  
  def index
    @groups = Group.front_page_order
  end
  
  def show
    @group = Group.find_by_short_name(params[:id])
  end

end