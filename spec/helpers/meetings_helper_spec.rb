require File.dirname(__FILE__) + '/../spec_helper'

#Delete this context and add some real ones or delete this file
context "Given a generated meetings_helper_spec.rb" do
  helper_name 'meetings'
  
  specify "the MeetingsHelper should be included" do
    (class << self; self; end).class_eval do
      included_modules.should include(MeetingsHelper)
    end
  end
end
