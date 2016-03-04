class ImpersonatesController < ApplicationController
  load_and_authorize_resource :user, :only => :create

  def create
    authorize! :impersonate, @user
    session[:admin_logged_in] = current_user.id
    sign_out current_user
    sign_in @user
    redirect_to dashboard_user_path(@user), :notice => "Signed in as #{@user.name}"
  end

  def destroy
    if session[:admin_logged_in].present?
      if user_signed_in?
        sign_out current_user
      end
      user = User.find(session[:admin_logged_in])
      sign_in user
      session[:admin_logged_in] = nil
      redirect_to user, :notice => "Signed back in as admin"
    else
      redirect_to root_path
    end
  end
end
