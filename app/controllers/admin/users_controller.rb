class Admin::UsersController < ApplicationController
  

  # before_action :check_admin
  before_filter :restrict_access
  before_filter :is_admin_redirect

  def index
    @users = User.all.page(params[:page]).per(2)
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params) 
    puts user_params 
    if @user.save
      redirect_to admin_users_path, notice: "You successfully created #{@user.firstname} with #{@user.admin?}!"
    else
      render :new
    end
  end

  # def current_admin
  #   @current_admin ||= User.find(session[:admin_id]) if session[:admin_id]
  # end

  def switch
    @user = User.find(params[:id])
    session[:user_id] = @user.id
    session[:can_switch] = false
    redirect_to movies_path, notice: "You've switched to #{@user.firstname}!"
  end


  def switchback
    session[:user_id] = session[:admin_id]
    session[:can_switch] = true
    @current_user = User.find(session[:admin_id])
    redirect_to admin_users_path, notice: "You've switched back to admin! (#{current_admin.full_name})"
  end

  
  def update

    @user = User.find(params[:id])

    if @user.update_attributes(user_params)
      redirect_to admin_users_path, notice: "You successfully updated #{@user.firstname}!"
    else
      render :edit
    end
  end

  def destroy

    @user = User.find(params[:id])
    if is_admin?
      username = @user.firstname
      @user.destroy
      UserMailer.termination_email(@user).deliver
      redirect_to admin_users_path, notice: "You successfully deleted the user, #{username}!"
    else
        render :new
    end
  end

  # def can_switch(user)
  #   user.id != session[:admin_id]
  # end

  protected
  
  def is_admin_redirect
    if !is_admin?
      flash[:alert] = "You must be an Admin to view this page."
      redirect_to movies_path
    end
  end

  def user_params
    params.require(:user).permit(
      :email, :password_digest, :firstname, :lastname, :admin
    )
  end


end