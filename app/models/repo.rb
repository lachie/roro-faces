class Repo < ActiveRecord::Base
  belongs_to :user

  before_validation :calculate_score

  named_scope :top, lambda {|n| n||=20; {:order => 'score DESC', :limit => n}}

  def calculate_score
    self.score = (fork? ? 0.5 : 1.0) * (forks + watchers - 1)
  end
end
