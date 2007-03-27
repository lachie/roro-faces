class FacetKindsController < ApplicationController
  append_before_filter :load_facet_kind, :only => [:edit,:update]
  append_before_filter :login_required
  
  def authorized?
    return true if %w{new create}.include? action_name
    current_user.admin?
  end
  
  def index
    @facet_kinds = FacetKind.find(:all)
  end
  
  def edit
  end
  
  def show
    redirect_to edit_facet_kind_path(params[:id])
  end
  
  def new
    @facet_kind = FacetKind.new
  end
  
  def update
    @facet_kind.attributes = params[:facet_kind]
    @facet_kind.save!
    flash[:notice] = "Saved."
  rescue ActiveRecord::RecordNotSaved
    flash[:notice] = "Failed to save."
  ensure
    render :action => 'edit'
  end
  
  def create
    @facet_kind = FacetKind.new(params[:facet_kind])
    @facet_kind.save!
    
    redirect_to_current_user
  rescue
    render :action => 'new'
  end
  
  protected
  def load_facet_kind
    @facet_kind = FacetKind.find(params[:id])
  end
end