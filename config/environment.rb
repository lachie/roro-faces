# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

# Dependencies.log_activity = true

require File.dirname(__FILE__)+'/shared_secret'
require 'active_support'

module FacesConfig
  mattr_accessor :numbr5_path
  self.numbr5_path = File.join(ENV['HOME'],'dev/ruby/numbr5')
end


Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here
  #


  # config.gem 'ruby-openid', :version => '~> 2.1.2', :lib => false
  
  # Skip frameworks you're not going to use (only works if using vendor/rails)
  config.frameworks -= [ :action_web_service ]

  # Only load the plugins named here, by default all plugins in vendor/plugins are loaded
  # config.plugins = %W( exception_notification ssl_requirement )

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level 
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper, 
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :user_observer

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
  
  # See Rails::Configuration for more options
  
  config.action_controller.session = { :session_key => "_faces_session", :secret => "zaphod beeblebrox? He's just this guy, you know?" }
  
  config.gem 'addressable', :lib => 'addressable/uri'
  config.gem 'mislav-will_paginate', :lib => 'will_paginate'
  config.gem 'chriseppstein-compass', :lib => 'compass'
  config.gem 'RedCloth'
  
  Dir.glob(File.join(RAILS_ROOT,'vendor','*','lib')).each do |dir|
    config.load_paths += [dir]
  end
  
end



# Add new inflection rules using the following format 
# (all these examples are active by default):
# Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

Mime::Type.register "image/svg+xml", :svg

# Ruby libs
require 'open-uri'
require 'yaml'
require 'fileutils'

# RubyGems
#require 'feed-normalizer'
# require 'RMagick'

require 'hash_ext'

# Include your application configuration below
require 'smtp_tls'
begin
  require RAILS_ROOT+'/config/gmail.rb'

  ActionMailer::Base.smtp_settings = {
    :address => "smtp.gmail.com",
    :port => "587",
    :domain => "localhost.localdomain",
    :authentication => :plain,
    :user_name => GMAIL_USER,
    :password => GMAIL_PASS
  }
rescue LoadError
  puts "WARNING: config/gmail.rb does not exists - using default ActionMailer settings (email may not work)"
end
