#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../../config/environment'
require 'csv'


count = 0
CSV.open("/Users/dayjp/Desktop/lmt_users_orig.csv", "r") do |row|
  unless count == 0
    role = Role.find_by_rolename(row[6])
    User.create(:login => row[1],
                :password => "password",
                :password_confirmation => "password",
                :email => row[5].blank? ? "temp#{count}@temp.com" : row[5],
                :first_name => row[2],
                :last_name => row[3],
                :address_1 => "",
                :address_2 => "",
                :city => "",
                :state => "",
                :zip => "",
                :phone => row[4].blank? ? "333-333-3333" : row[4],
                :role_id => role.id)
  end
  count += 1
end