class Group < ActiveRecord::Base
  has_many :affiliations
  has_many :users, :through => :affiliations
  has_many :meetings
  
  def to_param
    short_name
  end
end