class FrontController < ApplicationController
  def index
    @user = User.front_page_random.first
  end
end