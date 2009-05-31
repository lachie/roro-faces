class Meeting < ActiveRecord::Base
  belongs_to :group
  
  has_many :presos
  
  attr_writer :formatted_date, :formatted_time
  
  before_validation :parse_formatted
  
  validates_presence_of :date
  
  named_scope :by_date, lambda {|d| {:conditions => ['date(date)=?',d.to_date]}}

  #  and id in (select max(id) from meetings group by group_id)
  # named_scope :next,  :conditions => %{date > (current_date - interval '1 day')}, :order => 'date desc'

  named_scope :next,  :conditions => %{date > current_date}, :order => 'date desc'
  named_scope :previous, :condiitons => %{date < current_date}, :order => 'date desc'
  named_scope :last_analogue_blog, :conditions => %{row(date,group_id) in (
      select max(date),group_id from meetings where length(analogue_blog) > 0
      group by group_id)}, :order => 'date desc'
  
  
  def to_param
    self.date.to_date.to_s(:db)
  end
  
  def to_s
    self.date.to_s(:long_nice)
  end

  # feed
  def title
    "title"
  end

  def body_html
    "body"
  end
  
  def formatted_date; date.strftime('%d/%m/%Y') if date end
  def formatted_time; date.strftime('%H:%M'   ) if date end

  def partial; 'meetup' end
  
  protected
  def parse_formatted
    if @formatted_time && @formatted_date
      write_attribute(:date, DateTime.strptime("#{@formatted_date} #{@formatted_time}",'%d/%m/%Y %H:%M'))
    end
  end
  
  def filter_textile(text)
  end

  def apply_filter
    #self.analogue_blog_html = filter_textile(self.analogue_blog)
    #self.spiel_html         = filter_textile(self.spiel)
  end
end
