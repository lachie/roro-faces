class Thankyou < ActiveRecord::Base
  belongs_to :from, :class_name => 'User', :foreign_key => 'from_id'
  belongs_to :to  , :class_name => 'User', :foreign_key => 'to_id'  
  
  validates_presence_of :reason, :from_id, :to_id
  
  def feed_title
    "#{from.nick} owed #{to.nick} a beer"
  end
  
  def feed_description
    "#{from.nick} owed #{to.nick} a beer for #{reason}"
  end
  
  def feed_sort_date
    created_at
  end
  
  def to_xml(*options)
    public_attributes.to_xml(*options)
  end
  
  def to_json(*options)
    public_attributes.to_json
  end
  
  protected
    def public_attributes
      {
        :id => self.id,
        :from_id => self.from_id,
        :to_id => self.to_id
      }
    end
end
