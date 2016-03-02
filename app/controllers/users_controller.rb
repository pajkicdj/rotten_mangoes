class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      if admin?
        redirect_to admin_users_path, notice: "You successfully created #{@user.firstname}!"
      else
        session[:user_id] = @user.id
        redirect_to movies_path, notice: "Welcome aboard, #{@user.firstname}!"
      end
    else
      render :new
    end
  end

  def show
  end

  def destroy
    if !admin?
      @user = current_user
      @user.destroy
      username = @user.firstname
      session[:user_id] = nil
      redirect_to movies_path, notice: "Adios!"
    end
  end

  protected

  def user_params
    params.require(:user).permit(:email, :firstname, :lastname, :password, :password_confirmation)
  end
end
