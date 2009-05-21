class Grading < ActiveRecord::Base
  belongs_to :user
  
  has_many :grading_assignments
  has_many :grading_components
  
end
