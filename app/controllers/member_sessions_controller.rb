class MemberSessionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_member_sessions, only: [:show, :edit, :update, :destroy]
  before_action :check_permissions, only: [:show, :edit, :update, :destroy]

  def index
    if current_user.admin? || current_user.trainer?
      @member_sessions = MemberSession.includes(:user, :training_session).all
    else
      @member_sessions = current_user.member_sessions.includes(:user, :training_session).all
    end
  end

  def show
  end

  def new
    @member_session = current_user.member_sessions.new
  end

  def create
    @member_session = current_user.member_sessions.new(member_session_params)

    if @member_session.save
      redirect_to @member_session, notice: 'Member session was successfully created'
    else
      flash.now[:alert] = @member_session.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @member_session.update(member_session_params)
      redirect_to @member_session, notice: 'Member session was successfully updated'
    else
      flash.now[:alert] = @member_session.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @member_session.destroy
    redirect_to root_path, notice: 'Member session was successfully destroyed'
  end

  private

  def member_session_params
    params.require(:member_session).permit(:user_id, :training_session_id)
  end

  def set_member_sessions
    @member_session = MemberSession.includes(:user, :training_session).find(params[:id])
  end

  def check_permissions
    case current_user.role
    when 'admin'
      return true
    when 'trainer'
      return true
    else
      redirect_to root_path unless current_user == @member_session.user
    end
  end
end
