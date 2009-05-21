class Admin::SiteController < ApplicationController
  before_filter :login_required
  layout "admin"

  def index
    @site = Site.find :first
  end
  
  def new
    @site = Site.new
  end
  
  def create
    @site = Site.new(params[:site])
    @site.save
    if @site.errors.empty?
      redirect_back_or_default admin_site_index_path
    else
      render :action => 'new'
    end
  end
  
  def edit
    @site = Site.find params[:id]
  end
  
  def update
    @site = Site.find params[:id]
    if @site.update_attributes(params[:site])
      redirect_to admin_site_index_path
    else
      flash[:notice] = @site.errors.full_messages.join("<br/>")
      redirect_to edit_admin_site_path(@site)
    end
    
  end
  
  def destroy
    @site = Site.find params[:id]
    @site.destroy
    redirect_to admin_site_index_path
  end
  
  def meeting_dates
    @site = Site.find params[:id]
  end
  
  def create_meeting_dates
    @site = Site.find params[:id]
    if params[:commit]
      date = params[:meeting_date]["meeting_date(1i)"] + "-" + params[:meeting_date]["meeting_date(2i)"] + "-" + params[:meeting_date]["meeting_date(3i)"]
      @site.meeting_dates.create(:meeting_date => date)
      render :update do |page|
        page.replace_html 'meeting_dates', :partial => 'meeting_dates', :locals => { :site => @site }
        page.visual_effect :highlight, :meeting_dates
      end
    else
      render :update do |page|
        page.replace_html 'meeting_date', :partial => 'meeting_date', :locals => { :site => @site }
      end
    end
  end
  
  def edit_meeting_date
    @meeting_date = MeetingDate.find params[:id]
    if params[:commit]
      date = params[:meeting_date]["meeting_date(1i)"] + "-" + params[:meeting_date]["meeting_date(2i)"] + "-" + params[:meeting_date]["meeting_date(3i)"]
      @meeting_date.update_attribute(:meeting_date, date)
      @site = Site.find @meeting_date.site.id
      redirect_to meeting_dates_admin_site_path(@site)
    end
  end
  
  def delete_meeting_date
    @meeting_date = MeetingDate.find params[:id]
    @site = @meeting_date.site.id
    @meeting_date.destroy
    redirect_to meeting_dates_admin_site_path(@site)    
  end
  
end
