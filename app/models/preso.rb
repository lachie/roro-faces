class Preso < ActiveRecord::Base
  belongs_to :user
  belongs_to :meeting
  
  before_save :apply_filter
  
  def apply_filter
    self.description_html = FacesFormatter.format_as_xhtml(self.description)
  end
end
