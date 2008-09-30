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
  
  def apply_filter
    self.description_html = FacesFormatter.format_as_xhtml(self.description)
  end
end
