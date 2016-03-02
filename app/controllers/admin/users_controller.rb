class Admin::UsersController < ApplicationController

  # before_action :check_admin
  before_filter :restrict_access

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
  #   if @user.save
  #     redirect_to admin_users_path, notice: "You successfully created #{@user.firstname}!"
  #   else
  #     render :new
  #   end
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(user_params)
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  def destroy

    @user = User.find(params[:id])
    if admin?
      username = @user.firstname
      @user.destroy
      UserMailer.termination_email(@user).deliver
      redirect_to admin_users_path, notice: "You successfully deleted your user, #{username}!"
    else
        render :new
    end
  end

  protected

  def user_params
    params.require(:user).permit(
      :email, :password_digest, :firstname, :lastname, :admin, :checkbox_value
    )
  end


end