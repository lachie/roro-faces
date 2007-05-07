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
    return unless request.post?
    self.current_user = User.authenticate(params[:email], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_back_or_default(user_path(self.current_user))
      flash[:notice] = "Logged in successfully"
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
end
