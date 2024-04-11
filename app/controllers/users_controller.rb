class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @session = current_user
    @users = User.all
  end

  def show
    @session = current_user
    @user = User.find(params[:id])
  end

  def new
    @session = current_user
    @user = User.new
  end

  def create
    @session = current_user
    @user = User.new(user_params)

    if @user.save
      redirect_to user_path(@user), notice: "User created successfully"
    else
      flash.now[:alert] = @user.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @session = current_user
    @user = User.find(params[:id])
  end

  def update
    @session = current_user
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to user_path(@user), notice: "User updated successfully"
    else
      flash.now[:alert] = @user.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @session = current_user
    @user = User.find(params[:id])

    if current_user.isAdmin? && current_user.id != @user.id
      @user.destroy
      redirect_to users_path, notice: "User deleted successfully"
    else
      redirect_to users_path, alert: (current_user.id == @user.id ? "You cannot delete yourself" : "You do not have permission to delete this user")
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :role, :date_of_birth)
  end
end
