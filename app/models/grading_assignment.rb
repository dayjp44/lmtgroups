class GradingAssignment < ActiveRecord::Base
  belongs_to :grading
  belongs_to :grading_component
end
