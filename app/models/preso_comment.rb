class PresoComment < ActiveRecord::Base
  belongs_to :preso
  belongs_to :user
  
  before_save :apply_filter
  
  protected 
  def apply_filter
    self.comment_html = FacesFormatter.format_as_xhtml(self.comment)
  end
end
