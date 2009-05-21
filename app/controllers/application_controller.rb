# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include ExceptionNotifiable

  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery :only => [ :create, :update, :destroy ] # :secret => 'b38e3e2f8b365c3cadd03d70dbf5973b'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  filter_parameter_logging :password
  
  def log_email(to, coach, template, success)
    f = File.open("tmp/emails.txt", "a")
    if success == true
      action = "SUCCESS"
    else
      action = "FAIL"
    end
    if coach.nil?
      f.write("#{Time.now.strftime('%m-%d-%Y')} - #{action}: #{template} email sent to #{to.email}\n")
    else
      f.write("#{Time.now.strftime('%m-%d-%Y')} - #{action}: #{template} email sent by #{to.email} to #{coach.email}\n")
    end
    f.close
  end
  
end
