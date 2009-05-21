module Admin::UsersHelper
  
  def role_for_user(role_id)
    role = Role.find role_id
    return role.rolename
  end
end
