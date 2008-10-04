class Meeting < ActiveRecord::Base
  belongs_to :group
  
  has_many :presos
  
  attr_writer :formatted_date, :formatted_time
  
  before_validation :parse_formatted
  
  validates_presence_of :date
  
  def to_param
    self.date.to_s(:db)
  end
  
  def to_s
    self.date.to_s(:long_ordinal)
  end
  
  protected
  def parse_formatted
    write_attribute(:date, DateTime.strptime("#{@formatted_date} #{@formatted_time}",'%d/%m/%Y %H:%M'))
  end
end
