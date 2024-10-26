class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?, :admin?

  before_action :set_current_request_details
  before_action :authenticate

  def current_user
    @current_user ||= Current.session.user if Current.session.present?
  end

  def logged_in?
    current_user.present?
  end

  def admin?
    current_user&.admin?
  end

  def require_login
    redirect_to login_path, alert: 'You must be logged in to access this section' unless logged_in?
  end

  def require_admin
    redirect_to root_path, alert: 'Access restricted to admins only' unless admin?
  end

  private
    def authenticate
      if session_record = Session.find_by_id(cookies.signed[:session_token])
        Current.session = session_record
      else
        redirect_to sign_in_path
      end
    end

    def set_current_request_details
      Current.user_agent = request.user_agent
      Current.ip_address = request.ip
    end
end
