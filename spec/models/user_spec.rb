require File.dirname(__FILE__) + '/../spec_helper'

describe User, "bob" do
  include HornsbySpecHelper
  
  before(:each) do
    hornsby_scenario(:valid_users)
  end
  
  it "should be user" do
    @bob.should be_instance_of User
  end
  
  it "should return users in pinboard order" do
    User.find_for_pinboard.map(&:email).should == ['carl@carl.com','bob@bob.com']
  end
end