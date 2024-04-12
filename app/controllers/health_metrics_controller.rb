class HealthMetricsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_health_metric, only: [:show, :edit, :update, :destroy]
  before_action :check_permissions, only: [:show, :edit, :update, :destroy]

  def index
    if current_user.admin? || current_user.trainer?
      @health_metrics = HealthMetric.recent
    else
      @health_metrics = current_user.health_metrics.recent
    end
  end

  def show
  end

  def new
    @health_metric = current_user.health_metrics.new
  end

  def create
    @health_metric = current_user.health_metrics.new(health_metric_params)

    if @health_metric.save
      redirect_to @health_metric, notice: 'Log was successfully created'
    else
      flash.now[:alert] = @health_metric.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @health_metric.update(health_metric_params)
      redirect_to @health_metric, notice: 'Health metric was successfully updated'
    else
      flash.now[:alert] = @health_metric.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @health_metric.destroy
    redirect_to health_metrics_url, notice: 'Health metric was successfully destroyed'
  end

  private

  def health_metric_params
    params.require(:health_metric).permit(:height, :weight, :hydration, :muscle_mass, :caloric_intake, :caloric_burn, :steps, :sleep_quality, :resting_heart_rate)
  end

  def set_health_metric
    @health_metric = HealthMetric.find(params[:id])
  end

  def check_permissions
    case current_user.role
    when 'admin' || 'trainer'
      true
    else
      redirect_to root_path unless current_user == @health_metric.user
    end
  end
end
