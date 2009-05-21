class Admin::RolesController < ApplicationController
  before_filter :login_required
  layout "admin"
  
  def index
    @roles = Role.find :all  
  end

  def show
    @role = Role.find params[:id]
  end

  def new
    @role = Role.new
  end

  def create
    @role = Role.new(params[:role])
    @role.save
    if @role.errors.empty?
      redirect_back_or_default admin_roles_path
      flash[:notice] = "Role Created"
    else
      render :action => 'new'
    end
  end

  def edit
    @role = Role.find params[:id]
  end

  def update
    @role = Role.find params[:id]
    if @role.update_attributes(params[:role])
      redirect_to admin_roles_path
    else
      flash[:notice] = @role.errors.full_messages.join("<br/>")
    end
  end

  def destroy
    @role = Role.find params[:id]
    @role.permissions.each do |p|
      ActiveRecord::Base.connection.execute("DELETE FROM permissions_roles WHERE permission_id = #{p.id} AND role_id = #{@role.id}")      
    end
    @role.destroy
    redirect_to admin_roles_path
  end
  
  def permissions
    @permissions = Permission.find :all
    logger.debug(@permissions.to_yaml)
    @role = Role.find params[:id]
  end
  
  def update_permissions
    permissions = Permission.find :all
    @role = Role.find params[:id]
    @role.permissions.each do |p|
      ActiveRecord::Base.connection.execute("DELETE FROM permissions_roles WHERE permission_id = #{p.id} AND role_id = #{@role.id}")      
    end
    if params[:permission]
      params[:permission].keys.each do |key|
        ActiveRecord::Base.connection.execute("INSERT INTO permissions_roles (permission_id, role_id) VALUES (#{key}, #{@role.id})")
      end
    end
    redirect_to admin_roles_path
  end

end
