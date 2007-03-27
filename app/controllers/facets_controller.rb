class FacetsController < ApplicationController
  # append_before_filter :load_user, :only => [:create]
  append_before_filter :load_facet, :only => [:destroy]
  
  
  
  def new
    @facet = Facet.new :facet_kind_id => params[:facet_kind_id], :user_id => params[:user_id], :info => {}
  end
    
  def create
    @facet = Facet.new(params[:facet])
    @facet.save!
  end
  
  def destroy
    @facet.destroy
  end
  
  protected
  def load_user
    @user = User.find(params[:user_id])
  end
  
  def load_facet
    @facet = Facet.find params[:id]
  end
end