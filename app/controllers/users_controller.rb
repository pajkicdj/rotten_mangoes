class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
    
      session[:user_id] = @user.id
      redirect_to movies_path, notice: "Welcome aboard, #{@user.firstname}!"
    else
      render :new
    end
  end

  def edit
    current_user
  end

  def update

    if current_user.update_attributes(user_params)
      redirect_to user_path(current_user), notice: "Hey #{current_user.firstname}! You successfully updated your account!"
    else
      render :edit
    end
  end




#    @user = User.find(params[:id])




  def show
  end

  def destroy
    if !is_admin?
      @user = current_user
      @user.destroy
      username = @user.firstname
      session[:user_id] = nil
      redirect_to movies_path, notice: "Adios!"
    end
  end

  protected

  def user_params
    params.require(:user).permit(:email, :firstname, :lastname, :password, :password_confirmation, :admin, :id)
  end
end
