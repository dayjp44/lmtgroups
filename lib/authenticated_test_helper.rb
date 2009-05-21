module AuthenticatedTestHelper
  # Sets the current users in the session from the users fixtures.
  def login_as(users)
    @request.session[:users_id] = users ? users(users).id : nil
  end

  def authorize_as(user)
    @request.env["HTTP_AUTHORIZATION"] = user ? ActionController::HttpAuthentication::Basic.encode_credentials(users(user).login, 'test') : nil
  end
end
