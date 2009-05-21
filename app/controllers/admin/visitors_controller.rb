include Geokit::Geocoders

class Admin::VisitorsController < ApplicationController
  before_filter :login_required, :except => [:contacted]
  layout "admin"

  def index
    @visitors = Member.visitors(params[:page])
  end
  
  def new
    @visitor = Member.new
  end
  
  def create
    @visitor = Member.create(params[:member].merge(:inactive => 0, :status => "visitor"))
    @users = User.find :all, :origin => @visitor.zip, :within => 5, :conditions => ["role_id = ?", 3] 
    @users.each do |u|
      begin
        Notifications.deliver_visitor_contact(u, @visitor)
        log_email(u, nil, "visitor_contact", true)
      rescue
        log_email(u, nil, "visitor_contact", false)
      end
    end
    @visitors = Member.visitors(params[:page])
    render :update do |page|
      page.replace_html :visitors, :partial => "visitors", :locals => { :visitors => @visitors }
      page.visual_effect :highlight, :visitors
    end
  end
  
  def edit
    @visitor = Member.find params[:id]
  end
  
  def update
  end
  
  def destroy
    @visitor = Member.find params[:id]
    @visitor.destroy
    redirect_to admin_visitors_path
  end
  
end
