class Meeting < ActiveRecord::Base
  belongs_to :group
  
  has_many :presos
  
  attr_writer :formatted_date, :formatted_time
  
  before_validation :parse_formatted
  
  validates_presence_of :date
  
  named_scope :by_date, lambda {|d| {:conditions => ['date(date)=?',d.to_date]}}
  named_scope :next,  :conditions => %{date > (current_date - interval '1 day') and id in (select max(id) from meetings group by group_id)}, :order => 'date desc'
  #named_scope :this_week, :conditions => %{(date between (current_date - interval '1 day' and current_date + interval '1 week')}
  
  def to_param
    self.date.to_date.to_s(:db)
  end
  
  def to_s
    self.date.to_s(:long_nice)
  end
  
  def formatted_date; date.strftime('%d/%m/%Y') if date end
  def formatted_time; date.strftime('%H:%M'   ) if date end
  
  protected
  def parse_formatted
    if @formatted_time && @formatted_date
      write_attribute(:date, DateTime.strptime("#{@formatted_date} #{@formatted_time}",'%d/%m/%Y %H:%M'))
    end
  end
  
  def apply_filter
    self.analogue_blog_html = FacesFormatter.format_as_xhtml(self.analogue_blog)
    self.spiel_html = FacesFormatter.format_as_xhtml(self.spiel)
  end
end
