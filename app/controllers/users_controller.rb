class UsersController < ApplicationController
  append_before_filter :strip_permalink
  append_before_filter :load_user, :only => [:edit, :update, :show, :link_affiliation]

  append_before_filter :require_user, :only => [ :edit, :update ]
  append_before_filter :require_no_user, :only => [ :new, :create ]

  
  perform_caching && after_filter do |c|
    c.cache_page if (c.action_name == 'chatter' or c.action_name == 'all_chatter') and c.params[:format] == 'svg'
  end
  cache_sweeper :user_sweeper
  
  
  def index
    if nick = params[:nick]
      search_nick(nick)
    else
      return pinboard

      respond_to do |wants|
        
        wants.html do
          unless read_fragment('schooner')
            load_users
            @users_for_glass = @users.map(&:for_glass)
          end            
          render :action => 'index'
        end
        
        wants.rss  { load_users; do_index_rss }
        wants.xml  { load_users; render :text => @users.to_xml }
        wants.json { load_users; render_json @users.to_json }
      end
    end
  end
  
  def search
    @users = User.search(params[:q])
    respond_to do |wants|
      wants.html
    end
  end
  
  def search_nick(nick)
    user = User.find_by_stripped_irc_nick(nick) or raise ActiveRecord::RecordNotFound
    render :xml => user.to_xml
  rescue ActiveRecord::RecordNotFound
    render :nothing => true, :status => 404
  end
  
  def pinboard
    respond_to do |wants|
      wants.html do
        unless read_fragment('pinboard')
          @users = User.find_for_pinboard
        end
        render :action => 'index_simple'
      end
      wants.rss { do_index_rss }
    end
  end
  
  def thankyous
    # conditions = ['thankyous.created_at > ?', params[:since]] if params[:since]
    # 
    us = User.find(:all,:include => [:thankyous_to])
    # 
    # if since = params[:since]
    #   since = Time.parse(since)
    #   
    # end
    
    @users = us.reject {|u| u.thankyous_to.empty?}.sort_by {|u| u.thankyous_to.length}.reverse
  end
  
  def beerating
    @ratings = User.beeratings(:to)
    @thankers = User.beeratings(:from)
  end
  
  def chatter
    @page_title = 'chatter'
    @graph = 'chatter'
    @start = Time.now.to_i - 24*3600*3

    do_chatter
  end
  
  def all_chatter
    @page_title = 'all chatter'
    @graph = 'all_chatter'
    @start = 0
    
    do_chatter
  end
    
  def do_chatter
    respond_to do |wants|
      wants.svg do
        @users,@user_totals,@mentions,@total,@earliest = User.chatter(@start)
        @earliest = Time.at(@earliest)
        render :action => 'chatter'
      end
      wants.html { render :action => 'chatter' }
    end
  end
  

    
  def edit 
    if authorized?
      @facet_kinds = FacetKind.find_for_select.unshift(['',-1]).push(["-----",-1],["new facet kind...",0])
      @facet_kinds << ['edit facets...',-2] if current_user.admin?
      render :action => 'show_auth'
    end
  end
  
  def new
    @user = User.new
  end
  
  def show
    respond_to do |wants|
      wants.html do
        render :action => 'show'
      end
      wants.xml  { render :text => @user.to_xml }
      wants.json { render_json @user.to_json }
    end
  end
  
  def update
    @user.attributes = params[:user]
    @user.save do |result|
      if result
        redirect_to user_url(@user)
      else
        render :action => 'edit'
      end
    end
  end
  
  def create
    @user = User.new(params[:user])

    @user.save do |result|
      if result
        flash[:notice] = 'Successfully signed up'
        redirect_back_or_default user_path(@user)
      else
        render :action => 'new'
      end
    end
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
    
    render :partial => 'affiliation', :object => @affiliation
  end
  
  def self.chatter
  end
  
  protected
  def strip_permalink
    params[:id].split('-').first unless params[:id].blank?
  end
  
  def load_users
    @users = User.find(:all)
  end

  def load_user
    @user = User.find(params[:id])
  end
  
  def do_index_rss
    things = (@users + Thankyou.find(:all)).sort_by {|ut| ut.feed_sort_date}
    options = {
      :feed => {
        :title       => "roro facebook",
        :description => "The real faces of Rails Oceania people!"
      },
      :item => {
        :title       => [:nick,:feed_title],
        :description => :feed_description,
        :pub_date    => :feed_sort_date
      }
    }
    render_rss_feed_for things, options
  end

end
