# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  layout "site"
  
  # render new.rhtml
  def index
  end
  
  def new
  end

  def create
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        current_user.remember_me unless current_user.remember_token?
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      
      if current_user.admin?
        redirect_to admin_coaches_path
      elsif current_user.coach?
        redirect_to admin_coaches_path        
      else
        redirect_back_or_default site_index_path
      end
      flash[:notice] = "Logged in successfully"
    else
      flash[:notice] = "Username or Password incorrect"
      render :action => 'new'
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default root_path
  end
  
  def recover_password
    if params[:commit]
      user = User.find_by_sql("select * from users where email like '%#{params[:email].strip}%'")
      if user.blank?
        render :update do |page|
          page.replace_html 'recover_password', "<div class='notice'>The email address you provided, #{params[:email].strip} was not found. Please contact your coach.</div>"
          page.visual_effect :highlight, :recover_password
        end
      else
        begin
          Notifications.deliver_recover_password(user.first)
          log_email(user.first, nil, "recover_password", true)
        rescue
          log_email(user.first, nil, "recover_password", false)
        end
        render :update do |page|
          page.replace_html 'recover_password', "<div class='notice'>Your Password has been sent to #{user.first.email}</div>"
          page.visual_effect :highlight, :recover_password
        end
      end
    else
      render :update do |page|
        page.replace_html 'recover_password', :partial => 'recover_password'
      end
    end
  end

  def contacted
    @visitor = Member.find params[:id]
    @visitor.contacted = true
    @visitor.save
    @user = User.find params[:user_id]
    @users = User.find :all, :origin => @visitor.zip, :within => 10, :conditions => ["role_id = ?", 3] 
    @users.each do |u|
      begin
        Notifications.deliver_visitor_contacted(u, @visitor)
        log_email(u, nil, "visitor_contacted", true)
      rescue
        log_email(u, nil, "visitor_contacted", false)
      end
    end  
  end
  
end
