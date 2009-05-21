class Admin::FacilitatorsController < ApplicationController
  before_filter :login_required
  layout "admin"
  
  def index
    role = Role.find_by_rolename("Facilitator")
    @facilitators = User.find_all_by_role_id(role.id)
  end
  
  def members
    @facilitator = User.find params[:id]
    @members = Member.search(params[:search], params[:page])
  end
  
  def member_reports
    @facilitator = User.find params[:id]
    @reports = Report.find_all_by_user_id(@facilitator.id)
  end
  
  def edit_member_report
    if params[:commit]
      @facilitator = User.find params[:facilitator_id]
      @report = Report.find params[:id]
      date = params[:report]["date_of_meeting(1i)"] + "-" + params[:report]["date_of_meeting(2i)"] + "-" + params[:report]["date_of_meeting(3i)"]
      total_present = 0
      params[:member].keys.each do |key|
          total_present += params[:member][key].to_i
      end
      total_present += params[:report][:other_attendees_number].to_i
      if @report.update_attributes(:notes => params[:report][:notes],
                                   :user_id => @facilitator.id,
                                   :other_attendees_names => params[:report][:other_attendees_names],
                                   :other_attendees_number => params[:report][:other_attendees_number],
                                   :total_present => total_present,
                                   :offering_amount => params[:report][:offering_amount],
                                   :facilitated_by => params[:report][:facilitated_by],
                                   :intern => params[:report][:intern],
                                   :worship_leader => params[:report][:worship_leader],
                                   :meeting_location => params[:report][:meeting_location],
                                   :date_of_meeting => date)
         params[:member].keys.each do |member_id|
           member = Member.find member_id
           rd = ReportDetail.find_by_report_id_and_member_id(@report.id, member.id)
           unless rd.nil?
             rd.status = params[:member][member_id]
             rd.save
          end
         end
         redirect_to member_reports_admin_facilitator_path(@facilitator)
       else
         flash[:notice] = @report.errors.full_messages.join("<br/>")
         edit_member_report_admin_facilitator_path(:facilitator_id => @facilitator)
       end    
    else
      @report = Report.find params[:id]
      @facilitator = User.find @report.user_id
    end
  end
  
  def view_member_report
    @report = Report.find params[:id]
    @facilitator = User.find @report.user_id
  end
  
  def assign_member
    @facilitator = User.find params[:id]
    @member = Member.find params[:member_id]
    @member.user_id = @facilitator.id
    @member.save
    render :update do |page|
      page.replace_html 'assigned_members', :partial => 'assigned_members', :locals => { :facilitator => @facilitator }
      page.visual_effect :highlight, :assigned_members
    end
  end
  
  def unassign_member
    @facilitator = User.find params[:id]
    @member = Member.find params[:member_id]
    @member.user_id = nil
    @member.save
    render :update do |page|
      page.replace_html 'assigned_members', :partial => 'assigned_members', :locals => { :facilitator => @facilitator }
      page.visual_effect :highlight, :assigned_members
    end
  end  
end
