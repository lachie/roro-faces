# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_facebook_session_id'
  
  include ApplicationHelper

  before_filter :redirect_from_lachie_dot_info
    
  include AuthenticatedSystem
  before_filter :login_from_cookie
  
  around_filter :add_current_user_to_thread

  def logged_in_but_other_user?
    admin? or (@user and logged_in? and current_user != @user)
  end
  
  def authorized?
    current_user == @user or admin?
  end
  
  protected
    def redirect_from_lachie_dot_info
      if request.host == "faces.lachie.info"
        headers["Status"] = "301 Moved permanently, bruvva"
        redirect_to :host => "faces.rubyonrails.com.au"
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
