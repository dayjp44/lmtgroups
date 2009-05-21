class SiteController < ApplicationController
  before_filter :login_required
  
  def index
    @facilitator = current_user
  end
  
  def email_coach
    @facilitator = User.find params[:id]
    @coach = User.find @facilitator.coaches.first.id
    begin
      Notifications.deliver_email_to_coach(@facilitator, @coach, params[:email])
      log_email(@facilitator, @coach, "email_to_coach", true)
    rescue
      log_email(@facilitator, @coach, "email_to_coach", false)
    end
    render :update do |page|
      page.replace_html 'email_coach', :partial => 'email_coach', :locals => { :facilitator => @facilitator }
      page.visual_effect :highlight, "email_coach", :duration => 4.0
    end
  end
  
  def profile
    @facilitator = User.find params[:id]
  end

  def change_profile
    @facilitator = User.find params[:id]
    if @facilitator.update_attributes(params[:facilitator])
      redirect_to profile_site_path(@facilitator)
    else
      flash[:notice] = @facilitator.errors.full_messages.join("<br/>")
      redirect_to profile_site_path(@facilitator)
    end

  end
    
  def attendance_report
    @facilitator = User.find params[:id]
  end
  
  def report_new
    @facilitator = User.find params[:id]
    @meeting_dates = MeetingDate.find :all, :order => "id DESC"
  end
  
  def report_create
    @facilitator = User.find params[:id]
    total_present = 0
    params[:member].keys.each do |key|
        total_present += params[:member][key].to_i
    end
    total_present += params[:report][:other_attendees_number].to_i
    @report = Report.create(:notes => params[:report][:notes],
                            :user_id => @facilitator.id,
                            :other_attendees_names => params[:report][:other_attendees_names],
                            :other_attendees_number => params[:report][:other_attendees_number],
                            :total_present => total_present,
                            :offering_amount => params[:report][:offering_amount],
                            :facilitated_by => params[:report][:facilitated_by],
                            :intern => params[:report][:intern],
                            :worship_leader => params[:report][:worship_leader],
                            :meeting_location => params[:report][:meeting_location],
                            :date_of_meeting => params[:report][:date_of_meeting])
    
    if @report.errors.blank?
      params[:member].keys.each do |member_id|
        member = Member.find member_id
        ReportDetail.create(:report_id => @report.id, :member_id => member.id, :status => params[:member][member_id])
      end
      begin    
        Notifications.deliver_ar_confirmation(@facilitator, @report)
        log_email(@facilitator, nil, "ar_confirmation", true)
      rescue
        log_email(@facilitator, nil, "ar_confirmation", false)
      end
      redirect_to attendance_report_site_path(@facilitator)  
    else
      flash[:notice] = @report.errors.full_messages.join("<br/>")
      redirect_to report_new_site_path
    end
  end
  
  def report_edit
    @facilitator = User.find params[:facilitator_id]
    @report = Report.find params[:id]
    @meeting_dates = MeetingDate.find :all, :order => "id DESC"
  end
  
  def report_update
    @facilitator = User.find params[:facilitator_id]
    @report = Report.find params[:id]
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
                                 :date_of_meeting => params[:report][:date_of_meeting])
       params[:member].keys.each do |member_id|
         member = Member.find member_id
         rd = ReportDetail.find_by_report_id_and_member_id(@report.id, member.id)
         unless rd.nil?
           rd.status = params[:member][member_id]
           rd.save
         end
       end
       redirect_to attendance_report_site_path(@facilitator)
     else
       flash[:notice] = @report.errors.full_messages.join("<br/>")
       attendance_report_site_path(@facilitator)
     end    
  end
  
  def report_delete
    @report = Report.find params[:id]
    @facilitator = User.find params[:facilitator_id]
    @report.report_details.each do |rd|
      rd.destroy
    end
    @report.destroy
    redirect_to attendance_report_site_path(@facilitator)
  end
  
  def report_view
    @report = Report.find params[:id]
    @facilitator = User.find params[:facilitator_id]
  end

end
