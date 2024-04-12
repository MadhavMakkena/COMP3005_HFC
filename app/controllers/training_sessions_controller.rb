class TrainingSessionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_training_session, only: [:show, :edit, :update, :destroy]
  before_action :check_permissions, except: [:index, :show]
  before_action :set_users, only: [:new, :edit]

  def index
    @training_sessions = TrainingSession.includes(:user, :room_booking).all
  end

  def show
  end

  def new
    @training_session = TrainingSession.new
    @training_session.build_room_booking
  end

  def create
    @training_session = TrainingSession.new(training_session_params)

    if @training_session.save
      redirect_to @training_session, notice: 'Training session was successfully created'
    else
      flash.now[:alert] = @training_session.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end


  def edit
  end

  def update
    if @training_session.update(training_session_params)
      redirect_to @training_session, notice: 'Training session was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @training_session.destroy
    redirect_to training_sessions_url, notice: 'Training session was successfully destroyed'
  end

  private

  def set_training_session
    @training_session = TrainingSession.find(params[:id])
  end

  def training_session_params
    params.require(:training_session).permit(
      :name,
      :user_id,
      room_booking_attributes: [:room_name, :booking_time]
    )
  end

  def check_permissions
    unless current_user.admin? || current_user.trainer?
      redirect_to root_path, alert: 'You do not have permission to perform this action.'
    end
  end

  def set_users
    @users = User.where(trainer: true)
  end
end
