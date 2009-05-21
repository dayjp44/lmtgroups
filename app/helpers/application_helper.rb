# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def facilitator(user_id)
    unless user_id.blank? || user_id.nil?
      user = User.find user_id
      return user.last_name
    else
      return ""
    end    
  end

end
