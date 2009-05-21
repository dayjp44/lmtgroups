class Admin::MembersController < ApplicationController
  before_filter :login_required
  layout "admin"
  
  def index
    @members = Member.search(params[:search], params[:page])
  end
  
  def new
    @member = Member.new
  end
  
  def edit
    @member = Member.find params[:id]
  end
  
  def create
    @member = Member.new(params[:member].merge(:inactive => 0))
    @member.save
    if @member.errors.empty?
      redirect_back_or_default admin_members_path
      flash[:notice] = "Member Created"
    else
      render :action => 'new'
    end
  end
  
  def update
    @member = Member.find params[:id]
    if @member.update_attributes(params[:member])
      redirect_to admin_members_path
    else
      flash[:notice] = @member.errors.full_messages.join("<br/>")
      redirect_to edit_admin_member_path(@member)
    end
  end
  
  def destroy
    @member = Member.find params[:id]
    @member.inactive = true
    @member.save
    if params[:unassigned]
      redirect_to unassigned_members_admin_members_path
    else
      redirect_to admin_members_path
    end
  end
  
  def activate
    @member = Member.find params[:id]
    @member.inactive = false
    @member.save
    redirect_to inactive_members_admin_members_path    
  end
  
  def inactive_members
    @members = Member.find_all_by_inactive(true)
  end

  def unassigned_members
    allmembers = Member.find :all, :conditions => "inactive = false"
    @members = []
    allmembers.each do |mem|
      if mem.user.nil?
        @members << mem
      end
    end
  end
  
end
