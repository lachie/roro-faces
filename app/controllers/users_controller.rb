class UsersController < ApplicationController
  #skip_before_filter :login_from_cookie, :except => [:edit]
  append_before_filter :load_user, :only => [:edit,:update, :show, :link_affiliation]
  append_before_filter :login_required, :only => [ :edit, :update ]
  
  def authorized?
    current_user == @user or admin?
  end
  
  def index
    if nick = params[:nick]
      search(nick)
    else
      respond_to do |wants|
        wants.html do
          @users = User.find(:all)
          @users_for_glass = @users.map(&:for_glass)
          render :action => 'index'
        end
        wants.rss { do_index_rss }
      end
    end
  end
  
  def search(nick)
    user = User.find_by_stripped_irc_nick(nick)
    render :xml => user.to_xml
  rescue ActiveRecord::RecordNotFound
    render :nothing => true, :status => 404
  end
  
  def pinboard
    
    respond_to do |wants|
      wants.html do
        @users = User.find(:all).sort_by {rand}
        render :action => 'index_simple'
      end
      wants.rss { do_index_rss }
    end
    
  end
  
  def thankyous
    conditions = ['thankyous.created_at > ?', params[:since]] if params[:since]
    us = User.find(:all,:include => [:thankyous_to], :conditions => conditions)
    @users = us.reject {|u| u.thankyous_to.empty?}.sort_by {|u| u.thankyous_to.length}.reverse
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
  
  def do_index_rss
    things = (User.find(:all,:order => 'updated_at desc') + Thankyou.find(:all,:order => 'created_at desc')).sort_by {|ut| ut.feed_sort_date}
    options = {
      :feed => {
        :title => "roro facebook",
        :description => "The real faces of Rails Oceania people!"
      },
      :item => {
        :title => [:nick,:feed_title],
        :description => :feed_description,
        :pub_date => :feed_sort_date
      }
    }
    render_rss_feed_for things, options
  end

end