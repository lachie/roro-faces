class Mugshot < ActiveRecord::Base
  # --- HornsbyBuilder-associations start
	
	has_many :users
  # --- HornsbyBuilder-associations end
  
  has_one :user
  attr_accessor :user_id
    
  has_attachment :content_type => :image,
    :storage => :file_system,
    :resize_to => '150x150>',
    :thumbnails => {
      :thumb => 48
    },
    :processor => 'Bubble'
    
  validates_as_attachment
  
end
