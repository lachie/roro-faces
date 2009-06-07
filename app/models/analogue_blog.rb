class AnalogueBlog
  def self.new_from_meeting(meeting)
    unless meeting.analogue_blog.blank?
      new(meeting)
    end
  end

  def initialize(meeting)
    @meeting = meeting
  end

  def updated_at
    @meeting.blog_updated_at
  end

  def created_at
    @meeting.blog_created_at
  end

  def feed_title
    "#{group.name} : analogue blog : #{@meeting}"
  end

  def feed_partial
    'feed_blog'
  end

  def to_param
    @meeting.to_param
  end

  def feed_body
    @meeting.analogue_blog_html
  end

  def method_missing(method_id, *args, &block)
    @meeting.send(method_id, *args, &block)
  end
end
