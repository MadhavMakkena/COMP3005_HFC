class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :check_permissions, only: [:show, :edit, :update, :destroy]

  def index
    if current_user.admin?
      @users = User.all
    elsif current_user.trainer?
      @users = User.where(role: :member)
    else
      redirect_to root_path, alert: "You do not have permission to view all users"
    end
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to user_path(@user), notice: "User created successfully"
    else
      flash.now[:alert] = @user.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "User updated successfully"
    else
      flash.now[:alert] = @user.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if current_user.admin? && current_user.id != @user.id
      @user.destroy
      redirect_to users_path, notice: "User deleted successfully"
    else
      redirect_to users_path, alert: (current_user.id == @user.id ? "You cannot delete yourself" : "You do not have permission to delete this user")
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :role, :date_of_birth)
  end

  def check_permissions
    case current_user.role
    when 'admin'
      true
    when 'trainer'
      redirect_to root_path unless @user.role == 'member' || current_user == @user
    else
      redirect_to root_path unless current_user == @user
    end
  end
end
