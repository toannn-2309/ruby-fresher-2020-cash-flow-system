module RSpecTestHelper
  def log_in user
    request.session[:user_id] = user.id
  end

  def current_user
    User.find_by id: request.session[:user_id]
  end

  def admin?
    current_user.admin?
  end
end
