class ReportDetail < ActiveRecord::Base
  belongs_to :report
  has_many :members
end
