module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :current_user
    helper_method :current_user, :user_signed_in?
  end

  def login(user)
    reset_session
    session[:current_user_id] = user.id
  end

  def logout
    reset_session
    redirect_to login_path, notice: "Logged out successfully"
  end

  def authenticate_user!
    store_location
    redirect_to(login_path, alert: "You need to login to access this page") unless user_signed_in?
  end

  def redirect_if_authenticated
    redirect_to(root_path, alert: "You are already logged in") if user_signed_in?
  end

  private

  def current_user
    @current_user ||= User.find_by(id: session[:current_user_id])
  end

  def user_signed_in?
    current_user.present?
  end

  def store_location
    session[:user_return_to] = request.fullpath if request.get? && !request.xhr? && !user_signed_in?
  end
end
