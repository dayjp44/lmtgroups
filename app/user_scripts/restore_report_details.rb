#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../../config/environment'
require 'csv'

reports = Report.find :all
reports.each do |report|
  count = 0
  CSV.open("/Users/dayjp/Desktop/lmt_report_details_orig.csv", "r") do |row|
    unless count == 0
      if report.old_id == row[0].to_i
        member = Member.find_by_first_name_and_last_name(row[1].strip, row[2].strip)
        if member.nil?
          mem = Member.create(:first_name => row[1].strip, :last_name => row[2].strip)
          ReportDetail.create(:report_id => report.id,
                              :member_id => mem.id,
                              :status => row[3],
                              :created_at => report.date_of_meeting,
                              :updated_at => report.date_of_meeting)
        else
          ReportDetail.create(:report_id => report.id,
                              :member_id => member.id,
                              :status => row[3],
                              :created_at => report.date_of_meeting,
                              :updated_at => report.date_of_meeting)
        end
      end
    end
    puts count
    count += 1
  end
end