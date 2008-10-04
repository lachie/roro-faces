class Admin::PresosController < Admin::ApplicationController
  def show
    @preso = Preso.find(params[:id])
  end
end