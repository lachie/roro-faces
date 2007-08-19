class UserSweeper < ActionController::Caching::Sweeper
  observe User
  
  def after_save(user)
    expire_fragment('pinboard')
  end
end