#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../../config/environment'
require 'csv'

# History
user_id = 44
user = User.find user_id

count = 0
CSV.open("/Users/dayjp/Desktop/cg_restore_data/#{user.last_name.downcase}_reports.csv", "r") do |row|
  unless count == 0
    old_id = row[0]
    date = row[1]
    visitors = row[3].blank? ? 0 : row[3]
    notes = row[4]
    @report = Report.create(:user_id => user.id,
                            :notes => notes,
                            :other_attendees_number => visitors,
                            :old_id => old_id,
                            :date_of_meeting => date,
                            :offering_amount => 0,
                            :facilitated_by => user.last_name)
    num = 0
    CSV.open("/Users/dayjp/Desktop/cg_restore_data/#{user.last_name.downcase}_report_details.csv", "r") do |row|
      unless num == 0
        member = Member.find_by_first_name_and_last_name(row[1].strip, row[2].strip)
        if row[0].to_i == @report.old_id.to_i
          unless member.nil?
            @report.report_details.create(:member_id => member.id, :status => row[3])
          end
        end
      end
      num += 1
    end
    
    report_details = ReportDetail.find_all_by_report_id(@report.id)
    total = 0
    report_details.each do |d|
      if d.status == true
        total += 1
      end
    end
    @report.total_present = total + @report.other_attendees_number
    @report.save
  end
  count += 1
end

=begin
count = 0

CSV.open("/Users/dayjp/Desktop/lmt_reports_orig.csv", "r") do |row|
  unless count == 0
    if row[2] == "Casselman"
      user = User.find 37
    elsif row[2] == "Casselman, Rachel"
      user = User.find 36
    elsif row[2].include?("hist")
      user = User.find 44
    else
      user = User.find_by_last_name(row[2])
    end

    report = Report.create(:old_id => row[0],
                           :user_id => user.id,
                           :notes => row[4],
                           :other_attendees_number => row[3].blank? ? 0 : row[3],
                           :total_present => 0,
                           :offering_amount => 0,
                           :facilitated_by => "",
                           :intern => "",
                           :worship_leader => "",
                           :meeting_location => "",
                           :date_of_meeting => row[1])
    
    puts count
    puts report.errors.full_messages
  end
  count += 1
end
=end