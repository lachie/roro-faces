require File.dirname(__FILE__) + '/../spec_helper'

#Delete this context and add some real ones or delete this file
context "Given a generated presentations_helper_spec.rb" do
  helper_name 'presentations'
  
  specify "the PresentationsHelper should be included" do
    (class << self; self; end).class_eval do
      included_modules.should include(PresentationsHelper)
    end
  end
end
