#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../../config/environment'
require 'csv'


f = File.new("/Users/dayjp/Desktop/reports.csv", "w+")
users = User.find_by_sql("select * from users where role_id = 3 order by last_name")
users.each do |user|
  f.write("#{user.last_name}\n")
  user.reports.each do |r|
    f.write("#{r.date_of_meeting}\n")
  end
end
f.close

=begin
count = 0
CSV.open("/Users/dayjp/Desktop/lmt_members_orig.csv", "r") do |row|
  unless count == 0
    Member.create(:first_name => row[0],
                  :last_name => row[1],
                  :status => row[2].blank? ? "" : row[2],
                  :user_id => row[4])
  end
  puts count
  count += 1
end
=end