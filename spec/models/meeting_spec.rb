require File.dirname(__FILE__) + '/../spec_helper'

#Delete this context and add some real ones
context "Given a generated meeting_spec.rb with fixtures loaded" do
  fixtures :meetings

  specify "fixtures should load two Meetings" do
    Meeting.should have(2).records
  end
end
