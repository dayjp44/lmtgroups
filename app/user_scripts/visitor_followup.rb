#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../../config/environment'
require 'csv'


CSV.open("/Users/dayjp/Downloads/Visitors.csv", "r") do |row|
  visitor = Member.create(:first_name => row[0],
                          :last_name => row[1],
                          :zip => row[2],
                          :phone => row[3],
                          :notes => row[4],
                          :inactive => 0,
                          :status => "visitor")
  users = User.find :all, :origin => visitor.zip, :within => 5, :conditions => ["role_id = ?", 3] 
  users.each do |u|
    Notifications.deliver_visitor_contact(u, visitor)
  end
end