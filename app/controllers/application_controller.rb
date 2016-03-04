class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def restrict_access
    if !current_user
      flash[:alert] = "You must log in."
      redirect_to new_session_path
    end
  end


  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def is_admin?
    if current_user
      (@current_user.admin?.nil? || @current_user.admin? == false) ? false : true
    end
  end

  def current_admin
    @current_admin ||= User.find(session[:admin_id]) if session[:admin_id]
  end

  def is_switched?
    session[:can_switch] == false
  end





  helper_method :is_admin?
  helper_method :current_user
  helper_method :is_switched?
  helper_method :current_admin
 

end
