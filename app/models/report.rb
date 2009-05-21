class Report < ActiveRecord::Base
  belongs_to :user
  has_many :report_details
  
  #validates_presence_of :offering_amount
  #validates_numericality_of :offering_amount

end
