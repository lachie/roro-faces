class ThankyouSweeper < ActionController::Caching::Sweeper
  observe Thankyou
  
  def after_create(thankyou)
    expire_page(:controller => 'thankyous', :action => 'beergraph', :format => 'svg')
  end
end