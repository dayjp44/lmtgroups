require 'gruff'

class Admin::ReportsController < ApplicationController
  before_filter :login_required
  layout "admin"
  
  def index
    @three_month = Gruff::Line.new(430)
    @three_month.title = "Last Three Months Overall Attendance"
    three_months_ago = Time.now - 90.days
    today = Time.now
    @reports = Report.find_by_sql("select * from reports where date_of_meeting between '#{three_months_ago.strftime('%Y-%m-%d')}' and '#{today.strftime('%Y-%m-%d')}'")
      
    @three_month.data("Daily Net", attendance)
    #@daily_net.labels = {0 => month_ago.strftime("%m-%d"), 5 => twentyfive_days_ago.strftime("%m-%d"), 10 => twenty_days_ago.strftime("%m-%d"), 15 => fifteen_days_ago.strftime("%m-%d"), 20 => ten_days_ago.strftime("%m-%d"), 25 => five_days_ago.strftime("%m-%d"), 30 => Time.now.strftime("%m-%d")}
  end
  
end
