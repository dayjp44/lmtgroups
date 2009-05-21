module Admin::FacilitatorsHelper

  def member_for_report(id)
    member = Member.find id
    return member
  end
  
end
