require File.dirname(__FILE__) + '/../spec_helper'

#Delete this context and add some real ones
context "Given a generated presentations_controller_spec.rb" do
  controller_name 'presentations'
  
  specify "the controller should be a PresentationsController" do
    controller.should be_an_instance_of(PresentationsController)
  end
end

