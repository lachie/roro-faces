require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  include HornsbySpecHelper
  
  before(:each) do
    hornsby_scenario(:valid_users)
  end
  
  it "should be user" do
    @bob.should be_instance_of(User)
  end
  
  it ".find_for_pinboard should return users" do
    User.find_for_pinboard.map(&:email).sort.should == ['carl@carl.com','bob@bob.com','dave@dave.com','eddie@eddie.com','fred@fred.com'].sort
  end

  it ".find_for_pinboard should have some sort of limit to avoid memory blow out with a large number of users"
  
  it "should find a user by their irc nick" do
    User.find_by_stripped_irc_nick("dave").should == @dave
  end

  it "should strip off underscores when searching for a user by irc nick" do
    User.find_by_stripped_irc_nick("_dave_").should == @dave
  end

  it "should strip off underscores from the stored nick when searching for a user by irc nick" do
    User.find_by_stripped_irc_nick("eddie").should == @eddie
  end

  it "should find a user by their alternate irc nick" do
    User.find_by_stripped_irc_nick("[NRE]fred").should == @fred
  end

  it "should strip off underscores when searching for a user by alternate irc nick" do
    User.find_by_stripped_irc_nick("_[NRE]fred").should == @fred
  end
  
  it "should find a user that is _away" do
    User.find_by_stripped_irc_nick("eddie_away").should == @eddie    
  end

  it "should find a user that is _away_" do
    User.find_by_stripped_irc_nick("_eddie_away_").should == @eddie    
  end

  it "should find a user that is at lunch" do
    User.find_by_stripped_irc_nick("eddie_lunch").should == @eddie    
  end

  it "should find a user that is working" do
    User.find_by_stripped_irc_nick("eddie_working").should == @eddie    
  end



end
