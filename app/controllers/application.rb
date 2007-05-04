# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_facebook_session_id'
  
  include ApplicationHelper
  
  include AuthenticatedSystem
  before_filter :login_from_cookie

  def logged_in_but_other_user?
    admin? or (@user and logged_in? and current_user != @user)
  end
end
