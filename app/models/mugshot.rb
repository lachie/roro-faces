class Mugshot < ActiveRecord::Base
  has_one :user
  attr_accessor :user_id

  # has_attachment :content_type => :image,
  #     :storage => :file_system,
  #     :resize_to => '150x150>',
  #     :thumbnails => {
  #       :thumb => 48
  #     },
  #     :processor => 'Bubble'
  #     
  #   validates_as_attachment
  #   
  #   def regenerate_thumbnails
  #     temp_file = temp_path.blank? ? create_temp_file : temp_path
  #     attachment_options[:thumbnails].each { |suffix, size| create_or_update_thumbnail(temp_file, suffix, *size) }
  #   end
  #   
  #   def thumbnail_name_for(thumbnail = nil)
  #     return filename if thumbnail.blank?
  #     ext = nil
  #     basename = filename.gsub /\.\w+$/ do |s|
  #       ext = s; ''
  #     end
  #     "#{basename}_#{thumbnail}.png"
  #   end
  
end
