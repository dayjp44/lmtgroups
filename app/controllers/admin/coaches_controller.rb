class Admin::CoachesController < ApplicationController
  before_filter :login_required
  layout "admin"
  
  def index
    role = Role.find_by_rolename("Coach")
    @coaches = User.find_all_by_role_id(role.id)
  end
  
  def facilitators
    role = Role.find_by_rolename("Facilitator")
    @facilitators = User.find_all_by_role_id(role.id)
    @coach = User.find params[:id]
  end
  
  def notes
    @facilitator = User.find params[:id]
  end
  
  def add_notes
    @facilitator = User.find params[:id]
    render :update do |page|
      page.replace_html 'add_note', :partial => 'add_note', :locals => { :facilitator => @facilitator }
    end
  end
  
  def create_notes
    @facilitator = User.find params[:id]
    @facilitator.notes.create(:notes => params[:notes][:notes])
    render :update do |page|
      page.replace_html 'add_note', "<div id='add_note'></div>"
      page.replace_html 'notes', :partial => "notes", :locals => { :facilitator => @facilitator }
      page.visual_effect :highlight, :notes
    end
  end
  
  def edit_notes
    @note = Note.find params[:id]
    render :update do |page|
      page.replace_html "note_#{@note.id}", :partial => "edit_note", :locals => { :note => @note }
    end
  end
  
  def update_notes
    @note = Note.find params[:id]
    @note.update_attributes(:notes => params[:notes][:notes])
    render :update do |page|
      page.replace_html "note_#{@note.id}", :partial => "note", :locals => { :note => @note }
      page.visual_effect :highlight, "note_#{@note.id}"
    end
  end
  
  def delete_notes
    @note = Note.find params[:id]
    @facilitator = User.find params[:facilitator_id]
    @note.destroy
    render :update do |page|
      page.replace_html 'notes', :partial => "notes", :locals => { :facilitator => @facilitator }
      page.visual_effect :highlight, :notes
    end
  end
  
  def assign_facilitator
    @coach = User.find params[:id]
    @facilitator = User.find params[:facilitator_id]
    FacilitatorAssignment.create(:coach_id => @coach.id, :facilitator_id => @facilitator.id, :position => 0)
    render :update do |page|
      page.replace_html 'assigned_facilitators', :partial => 'assigned_facilitators', :locals => { :coach => @coach }
      page.visual_effect :highlight, :assigned_facilitators
    end
  end
  
  def unassign_facilitator
    @coach = User.find params[:id]
    @facilitator = User.find params[:facilitator_id]
    @fa = FacilitatorAssignment.find_by_coach_id_and_facilitator_id(@coach.id, @facilitator.id)
    @fa.destroy
    render :update do |page|
      page.replace_html 'assigned_facilitators', :partial => 'assigned_facilitators', :locals => { :coach => @coach }
      page.visual_effect :highlight, :assigned_facilitators
    end
  end
  
  def facilitator_status
    @facilitator = User.find params[:id]
    render :update do |page|
      page.replace_html "status_#{@facilitator.id}", :partial => "status_update", :locals => { :facilitator => @facilitator }
    end
  end
  
  def facilitator_status_update
    @facilitator = User.find params[:id]
    @facilitator.status = params[:status]
    @facilitator.save
    render :update do |page|
      page.replace_html "status_#{@facilitator.id}", :partial => "status", :locals => { :status => @facilitator.status, :facilitator => @facilitator }
      page.visual_effect :highlight, "status_#{@facilitator.id}"
    end
  end  

  def grading
    @facilitator = User.find params[:id]
    @coach = @facilitator.coaches.first
  end

  def new_grading
    @facilitator = User.find params[:id]
    @coach = User.find params[:coach_id]
    @grading = Grading.new
    @grading_components = GradingComponent.find :all, :order => "name"
  end
  
  def create_grading
    @facilitator = User.find params[:id]
    @coach = Coach.find params[:coach_id]
    @grading = Grading.create(:user_id => @facilitator.id)
    params[:grading_components].keys.each do |key|
      @grading.grading_assignments.create(:grading_component_id => params[:grading_components][key])
    end
  end
  
  def edit_grading
    @grading = Grading.find params[:id]
  end
  
  def update_grading
    @grading = Grading.find params[:id]
  end
  
  def delete_grading
    @grading = Grading.find params[:id]
    @grading.grading_assignments.map{|g| g.destroy}
    @grading.destroy
  end
  
end
