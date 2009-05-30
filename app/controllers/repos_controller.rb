class ReposController < ApplicationController
  def index
    @repos = Repo.top.paginate(:page => params[:page], :per_page => 20)
  end
end
