class PresoRating < ActiveRecord::Base
  belongs_to :preso
  belongs_to :user
end