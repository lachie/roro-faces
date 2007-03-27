class UsersController < ApplicationController
  #skip_before_filter :login_from_cookie, :except => [:edit]
  append_before_filter :load_user, :only => [:edit,:update, :show, :link_affiliation]
  append_before_filter :login_required, :only => [ :edit, :update ]
  
  def authorized?
    current_user == @user
  end
  
  def index
    @users = User.find(:all)
    @users_for_glass = @users.map(&:for_glass)
    render :action => (params[:simple] ? 'index_simple' : 'index')
  end
  
  
  def edit 
  end
  
  def new
    @user = User.new
  end
  
  def show
    if authorized?
      @facet_kinds = FacetKind.find_for_select.unshift(['',-1]).push(["-----",-1],["new facet kind...",0])
      @facet_kinds << ['edit facets...',-2] if current_user.admin?
    end
    
    render :action => (authorized? and !params[:preview] ? 'show_auth' : 'show')
  end
  
  def update
    @user.attributes = params[:user]
    @user.save!
    
    redirect_to user_url(@user)
  rescue
    render :action => 'edit'
  end
  
  def create
    @user = User.new(params[:user])
    self.current_user = @user
    @user.save!
    
    redirect_to user_url(@user)
  rescue
    render :action => 'new'
  end
  
  def link_affiliation
    affiliation = {
      :group_id  => params[:group_id ],
      :linked    => params[:linked   ],
      :visitor   => params[:visitor  ],
      :presenter => params[:presenter],
      :regular   => params[:regular  ]
    }
    @affiliation = @user.ensure_affiliation(affiliation)
  end
  
  protected
  def load_user
    @user = User.find(params[:id])
  end

end