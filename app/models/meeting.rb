class Meeting < ActiveRecord::Base
  belongs_to :group
  
  has_many :presos
  
  def to_param
    self.date.to_s(:db)
  end
end
