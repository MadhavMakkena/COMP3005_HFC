class SessionsController < ApplicationController
  before_action :redirect_if_authenticated, only: [:new, :create]

  def create
    @user = User.find_by(email: params[:user][:email])

    if @user
      after_login_path = session[:user_return_to] || root_path
      login(@user)
      redirect_to after_login_path, notice: "Logged in successfully"
    else
      flash.now[:alert] = "Invalid email"
      render :new, status: :unauthorized
    end
  end

  def destroy
    logout
    redirect_to login_path, notice: "Logged out successfully"
  end

  def new
  end
end
