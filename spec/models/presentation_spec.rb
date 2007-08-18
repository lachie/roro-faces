require File.dirname(__FILE__) + '/../spec_helper'

#Delete this context and add some real ones
context "Given a generated presentation_spec.rb with fixtures loaded" do
  fixtures :presentations

  specify "fixtures should load two Presentations" do
    Presentation.should have(2).records
  end
end
