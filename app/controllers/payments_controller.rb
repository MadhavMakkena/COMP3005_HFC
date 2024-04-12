class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_payment, only: [:show, :edit, :update, :destroy]
  before_action :check_permissions, only: [:show, :edit, :update, :destroy]

  def index
    @payments = Payment.all
    redirect_to root_path
  end

  def show
  end

  def new
    @payment = Payment.new
    redirect_to root_path
  end

  def create
    @payment = Payment.new(payment_params)

    if @payment.save
      redirect_to root_path, notice: 'Payment was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @payment.update(payment_params)
      redirect_to root_path, notice: 'Payment was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @payment.destroy
    redirect_to root_path, notice: 'Payment was successfully destroyed.'
  end

  private

  def set_payment
    @payment = Payment.find(params[:id])
  end

  def payment_params
    params.require(:payment).permit(:user_id, :payment_date)
  end

  def check_permissions
    case current_user.role
    when 'admin'
      true
    else
      redirect_to root_path, alert: 'You do not have permission to access this page'
    end
  end
end
