class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  belongs_to :user
  
  before_save :apply_filter
  
  def rates?
    !(rating_length.nil? && rating_content.nil? && rating_slides.nil?)
  end
  
  protected 
  def apply_filter
    self.comment_html = FacesFormatter.format_as_xhtml(self.comment)
  end
end