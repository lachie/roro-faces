class FacetsController < ApplicationController
  # append_before_filter :load_user, :only => [:create]
  append_before_filter :load_facet, :only => [:destroy]
  
  
  def index
    @facet_kinds = FacetKind.find(:all,:include => :facets).sort_by {|facet_kind| -facet_kind.facets.size}
  end
  
  def new
    @facet = Facet.new :facet_kind_id => params[:facet_kind_id], :user_id => params[:user_id], :info => {}
    
    render :partial => 'form'
  end
    
  def create
    @facet = Facet.new(params[:facet])
    @facet.save!
    
    render :partial => 'users/facet', :object => @facet
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