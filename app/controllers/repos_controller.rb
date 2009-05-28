class ReposController < ApplicationController
  def index
    @repos = Repo.top
  end
end
