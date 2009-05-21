class FacilitatorAssignment < ActiveRecord::Base
  belongs_to :facilitator, :class_name => "User", :foreign_key => "facilitator_id"
  belongs_to :coach, :class_name => "User", :foreign_key => "coach_id"
end
