class ThankyouObserver < ActiveRecord::Observer
  def after_create(thankyou)
    Thankyou.draw_graph(:all)
  end
end