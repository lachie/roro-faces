class GroupsController < ApplicationController
  def show
    @group = Group.find_by_short_name params[:id]
  end
end