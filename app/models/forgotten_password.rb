class ForgottenPassword < ActionMailer::Base
  def reset_password(user)
     recipients user.email
     from       "lachiec@gmail.com"
     subject    "Reset password for roro facebook"
     body       :user => user
   end
end
