class RoomBookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room_booking, only: [:show, :edit, :update, :destroy]
  before_action :check_trainer_or_admin, except: [:show]

  def index
    @room_bookings = RoomBooking.all
  end

  def show
  end

  def new
    @room_booking = RoomBooking.new
  end

  def create
    @room_booking = RoomBooking.new(room_booking_params)

    if @room_booking.save
      redirect_to @room_booking, notice: 'Room was successfully booked'
    else
      flash.now[:alert] = @room_booking.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @room_booking.update(room_booking_params)
      flash[:notice] = 'Room booking was successfully updated'
      redirect_to @room_booking
    else
      flash.now[:alert] = @room_booking.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @room_booking.destroy
    redirect_to room_bookings_url, notice: 'Room booking was successfully destroyed'
  end

  private

  def set_room_booking
    @room_booking = RoomBooking.find(params[:id])
  end

  def room_booking_params
    params.require(:room_booking).permit(:room_name, :booking_time)
  end

  def check_trainer_or_admin
    unless current_user.admin? || current_user.trainer?
      redirect_to root_path, alert: 'You are not authorized to manage room bookings'
    end
  end
end
