require 'base64'

class AccountsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  #include AuthenticatedSystem
  # If you want "remember me" functionality, add this before_filter to Application Controller
  #before_filter :login_from_cookie

  # say something nice, you goof!  something sweet.
  def index
    redirect_to(:action => 'signup') unless logged_in? || User.count > 0
  end

  def login
    return unless request.post? || using_open_id?
    if using_open_id?
      open_id_authentication
    else
      self.current_user = User.authenticate(params[:email], params[:password])
      if logged_in?
        successful_login
      else
        failed_login("Invalid user name or password")
      end
    end
  end

  def signup
    @user = User.new(params[:user])
    return unless request.post?
    @user.save!
    self.current_user = @user
    redirect_back_or_default(user_path(@user))
    flash[:notice] = "Thanks for signing up!"
  rescue ActiveRecord::RecordInvalid
    render :action => 'signup'
  end
  
  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(users_path)
  end
  
  def reset_password
    user = User.find_by_email(params[:email])
    raise "couldn't find user with email '#{params[:email]}'" unless user
    
    User.transaction do
      user.password = user.password_confirmation = Base64.encode64(rand.to_s)[0,8].downcase
      user.save!
      ForgottenPassword.deliver_reset_password(user)
    end
    
    flash[:notice] = "password reset message sent to #{params[:email]}"
    redirect_to login_path
  rescue
    flash[:notice] = "failed to reset your password: #{$!}"
    logger.warn $!
    redirect_to login_path
  end
  
  protected
    def open_id_authentication
      authenticate_with_open_id do |result, identity_url|
        if result.successful?
          if self.current_user = User.find_by_openid(identity_url)
            successful_login
          else
            failed_login "Sorry, no user by that identity URL exists (#{identity_url})"
          end
        else
          failed_login result.message
        end
      end
    end

    def successful_login
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_back_or_default(user_path(self.current_user))
      flash[:notice] = "Logged in successfully"
    end

    def failed_login(message)
      flash[:error] = message
      redirect_back_or_default(login_url)
    end

end
