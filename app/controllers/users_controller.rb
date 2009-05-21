include Geokit::Geocoders

class UsersController < ApplicationController  
  before_filter :login_required
  
  # render new.rhtml
  def new
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @users = Users.new(params[:users])
    @users.save
    if @users.errors.empty?
      res = MultiGeocoder.geocode(@user.zip)
      @user.lat = res.lat
      @user.lng = res.lng
      @user.country = "United States"
      @user.save
      self.current_users = @users
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!"
    else
      render :action => 'new'
    end
  end

end
