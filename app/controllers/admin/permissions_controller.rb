class Admin::PermissionsController < ApplicationController
  before_filter :login_required
  layout "admin"
      
  def index
    @permissions = Permission.find :all  
  end
  
  def show
    @permission = Permission.find params[:id]
  end
  
  def new
    @permission = Permission.new
  end
  
  def create
    @permission = Permission.new(params[:permission])
    @permission.save
    if @permission.errors.empty?
      redirect_back_or_default admin_permissions_path
      flash[:notice] = "Permission Created"
    else
      render :action => 'new'
    end
  end
  
  def edit
    @permission = Permission.find params[:id]
  end
  
  def update
    @permission = Permission.find params[:id]
    if @permission.update_attributes(params[:permission])
      redirect_to admin_permissions_path
    else
      flash[:notice] = @permission.errors.full_messages.join("<br/>")
    end
  end
  
  def refresh_permissions
    Permission.update_all
    redirect_to admin_permissions_path
  end
  
  def destroy
    @permission = Permission.find params[:id]
    @permission.destroy
    redirect_to admin_permissions_path
  end

end
