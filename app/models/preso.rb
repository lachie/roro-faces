class Preso < ActiveRecord::Base
  belongs_to :user
  belongs_to :meeting
  
  has_many :comments, :as => :commentable
  has_many :preso_ratings
  
  before_save :apply_filter
  
  # def allow_feedback?
  #     puts "allow_feedback?..."
  #     current_user = Thread.current[:user]
  #     puts "cu #{current_user}"
  #     
  #     current_user && read_attribute(:allow_feedback) && !preso_comments.any? {|pc| current_user.id == pc.user_id && pc.rates? }
  #   end
  
  def to_s
    title
  end
  
  def apply_filter
    self.description_html = Pygments.render(self.description)
  end
  
  def avg_rating
    fields = %w{content slides length}.map {|f| "avg(#{f}) as avg_#{f}"} * ','
    connection.select_one("select #{fields}, count(*) as count from preso_ratings where preso_ratings.preso_id=#{id}")
  end
  
  def user_rated?(user)
    preso_ratings.count(:conditions => ['user_id = ?',user.id]) > 0
  end
end
