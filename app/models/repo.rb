class Repo < ActiveRecord::Base
  belongs_to :user

  before_validation :calculate_score

  named_scope :top, lambda {|n| n||=20; {:order => 'score DESC', :limit => n}}
  named_scope :front_page_random, :conditions => 'fork=False', :order => 'random()', :limit => 1
  #named_scope :front_page_random, :order => 'random()', :limit => 1, :conditions => 'mugshot_file_name is not null'
  

  def full_name
    "#{username}/#{name}"
  end

  def calculate_score
    self.score = (fork? ? 0.5 : 1.0) * (forks + watchers - 1)
  end
end
