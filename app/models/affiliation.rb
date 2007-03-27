class Affiliation < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  
  def self.stub_all_possible_affiliations(user=nil)
    Group.find(:all).collect do |g|
      self.new(:group => g, :user => user)
    end
  end
end
