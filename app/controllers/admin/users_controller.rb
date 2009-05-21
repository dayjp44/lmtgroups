include Geokit::Geocoders

class Admin::UsersController < ApplicationController
  before_filter :login_required
  layout "admin"
  
  def index
    @users = User.find :all
  end

  def new
    @user = User.new
  end
  
  def edit
    @user = User.find params[:id]
  end
  
  def update
    @user = User.find params[:id]
    if @user.update_attributes(params[:user])
      res = MultiGeocoder.geocode(@user.zip)
      @user.lat = res.lat
      @user.lng = res.lng
      @user.save
      redirect_to admin_users_path
    else
      flash[:notice] = @user.errors.full_messages.join("<br/>")
      redirect_to edit_admin_user_path(@user)
    end
  end
  
  def destroy
    @user = User.find params[:id]
    @user.destroy
    redirect_to admin_users_path
  end
  
  def show
    @user = User.find params[:id]
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.save
    if @user.errors.empty?
      res = MultiGeocoder.geocode(@user.zip)
      @user.lat = res.lat
      @user.lng = res.lng
      @user.country = "United States"      
      #self.current_user = @user
      redirect_back_or_default admin_users_path
      flash[:notice] = "Thanks for signing up!"
    else
      render :action => 'new'
    end
  end

end
