class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      if user.admin?
        session[:user_id] = user.id
        session[:admin_id] = user.id
        session[:can_switch] = true
        redirect_to movies_path, notice: "Welcome back, #{user.firstname}! (ADMIN)"
      else
        session[:user_id] = user.id
        redirect_to movies_path, notice: "Welcome back, #{user.firstname}!"
      end
    else
      flash.now[:alert] = "Log in failed..."
      render :new
    end
  end

  def destroy
    user = User.find(session[:user_id])
    if user.admin?
      session[:user_id] = nil
      session[:admin_id] = nil
      session[:can_switch] = nil
      redirect_to movies_path, notice: "Adios!"
    else
      session[:user_id] = nil
      redirect_to movies_path, notice: "Adios!"
    end
  end
end
