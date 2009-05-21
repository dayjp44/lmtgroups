class Notifications < ActionMailer::Base

  def ar_confirmation(user, report)
    @coach = User.find user.coaches.first.id
    emails = @coach.email.split(",") + ["main@landmarktabernacle.org"]
    @recipients = emails
    @from = user.email
    @content_type = "text/html"
    @subject = "Attendance Report Alert"

    @body["message"] = "#{user.first_name} #{user.last_name} has filled out an attendance report!"
    @body["report"] = report
  end
  
  def email_to_coach(facilitator, coach, message)
    emails = coach.email.split(",") + ["main@landmarktabernacle.org"]
    @recipients = emails
    @from = facilitator.email
    @content_type = "text/html"
    @subject = "Note from #{facilitator.first_name} #{facilitator.last_name}"

    @body["message"] = message
  end

  def recover_password(user)
    emails = user.email.split(",")
    @recipients = emails
    @from = "info@lmtgroups.com"
    @content_type = "text/html"
    @subject = "LMTGroups.com Password Recovery"

    @body["title"] = "LMTGroups.com Password Recovery"
    @body["message"] = "Your new password is #{user.new_password}.  Please remember to update your profile and change your password!"
  end
  
  def visitor_contact(user, visitor)
    emails = user.email.split(",")
    @recipients = emails
    @from = "info@lmtgroups.com"
    @content_type = "text/html"
    @subject = "LMTGroups.com Visitor Followup"
    
    @body["title"] = "LMTGroups.com: A visitor needs to be contacted!"
    @body["user"] = user
    @body["visitor"] = visitor
  end
  
  def visitor_contacted(user, visitor)
    emails = user.email.split(",")
    @recipients = emails
    @from = "info@lmtgroups.com"
    @content_type = "text/html"
    @subject = "LMTGroups.com Visitor Followup"
    
    @body["title"] = "LMTGroups.com: Visitor has been contacted"
    @body["user"] = user
    @body["visitor"] = visitor
  end
end