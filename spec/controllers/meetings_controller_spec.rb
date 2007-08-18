require File.dirname(__FILE__) + '/../spec_helper'

#Delete this context and add some real ones
context "Given a generated meetings_controller_spec.rb" do
  controller_name 'meetings'
  
  specify "the controller should be a MeetingsController" do
    controller.should be_an_instance_of(MeetingsController)
  end
end

