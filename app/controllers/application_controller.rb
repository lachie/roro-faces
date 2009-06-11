# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  #session :session_key => '_facebook_session_id'
  
  #include ApplicationHelper

  before_filter :redirect_from_lachie_dot_info
    
  helper :all
  helper_method :current_user_session, :current_user, :superuser?, :logged_in?, :logged_in_but_other_user?, :admin?, :authorized?

  filter_parameter_logging :password, :password_confirmation
  
  before_filter :load_globals
  around_filter :add_current_user_to_thread


  protected

  def logged_in_but_other_user?
    current_user && (admin? || superuser? || (@user && logged_in? && current_user != @user))
  end
  
  def authorized?(user=@user)
    current_user && current_user == user || admin? || superuser?
  end
  
  def superuser?
    current_user && current_user.superuser?
  end

  def admin?
    current_user && current_user.admin?
  end

  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def logged_in?
    !! current_user
  end
  
  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to account_url
      return false
    end
  end
  
  def store_location
    session[:return_to] = request.request_uri
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end


  def load_globals
    @repo = Repo.front_page_random.first
    @next_meetups = Meeting.next.all(:include => :group)
    # groups without meetups
    @sidebar_groups  = Group.regular.others(@next_meetups.map {|m| m.group_id})
  end

  def redirect_from_lachie_dot_info
    if request.host == "faces.lachie.info" || request.host == "faces.rubyonrails.com.au"
      headers["Status"] = "301 Moved permanently, bruvva"
      redirect_to :host => "faces.rubyoceania.org"
      return false
    end
  end

  def render_json(json, options={})
    callback, variable = params[:callback], params[:variable]
    response = begin
      if callback && variable
        "var #{variable} = #{json};\n#{callback}(#{variable});"
      elsif variable
        "var #{variable} = #{json};"
      elsif callback
        "#{callback}(#{json});"
      else
        json
      end
    end
    render({:content_type => 'text/javascript', :text => response}.merge(options))
  end
  
  def add_current_user_to_thread
    Thread.current[:user] = current_user
    
    yield
    
  ensure
    Thread.current[:user] = nil
  end
end
