class Meeting < ActiveRecord::Base
  belongs_to :group
  
  has_many :presos
  
  attr_writer :formatted_date, :formatted_time
  
  before_validation :parse_formatted
  before_validation :update_blog_timestamps
  
  validates_presence_of :date

  before_save :apply_filter
  
  named_scope :by_date, lambda {|d| {:conditions => ['date(date)=?',d.to_date]}}

  #  and id in (select max(id) from meetings group by group_id)
  # named_scope :next,  :conditions => %{date > (current_date - interval '1 day')}, :order => 'date desc'

  named_scope :next,  :conditions => %{date > current_date}, :order => 'date desc'
  named_scope :previous, :condiitons => %{date < current_date}, :order => 'date desc'

  # NOTE this probably won't work in mysql
  named_scope :last_analogue_blog, :conditions => %{row(date,group_id) in (
      select max(date),group_id from meetings 
      where date < current_date
      group by group_id)}, :order => 'date desc'
  

  def as_blog
    AnalogueBlog.new_from_meeting(self)
  end
  
  def to_param
    self.date.to_date.to_s(:db)
  end
  
  def to_s
    self.date.to_s(:long_nice)
  end

  # feed
  def self.feed_list
    a = all.map {|m| [m, m.as_blog].compact}.flatten
    logger.debug a.pretty_inspect
    
    a.compact.sort {|a,b| a.updated_at <=> b.updated_at}
  end

  def feed_title
    "#{group.name} meetup #{self}"
  end

  def feed_body
    spiel_html
  end

  def feed_url
    "http://faces.rubyoceania.org/groups/#{group.to_param}/meetings/#{self.to_param}"
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
  
  def apply_filter
    self.analogue_blog_html = Pygments.render(self.analogue_blog)
    self.spiel_html         = Pygments.render(self.spiel)
  end

  def update_blog_timestamps
    if changes['analogue_blog']
      now = self.blog_updated_at = Time.now
      # created
      if changes['analogue_blog'][0].blank? && !changes['analogue_blog'][1].blank?
        self.blog_created_at = now
      end
    end
  end
end
