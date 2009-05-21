module Admin::RolesHelper
  def assigned_permission(role_id, permission_id)
    role = Role.find role_id
    if role.permissions.blank?
      return false
    else
      ids = role.permissions.map{|p| p.id}
      if ids.include?(permission_id) 
        return true
      else
        return false
      end
    end
  end
end
