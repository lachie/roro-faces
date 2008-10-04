module Admin
  class ApplicationController < ::ApplicationController
    before_filter :require_admin
    
    helper :admin
    
    def index
    end
    
    protected
    def require_admin
      unless admin?
        flash[:shoo] = 'please be an admin, mmkay.'
        redirect_to '/'
      end
    end
  end
end