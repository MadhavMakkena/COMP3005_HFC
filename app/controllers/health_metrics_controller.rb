class HealthMetricsController < ApplicationController
  before_action :authenticate_user!

  def index
    @session = current_user
    @health_metrics = current_user.health_metrics.recent
  end

  def show
    @session = current_user
    @health_metric = current_user.health_metrics.find(params[:id])
  end

  def new
    @session = current_user
    @health_metric = current_user.health_metrics.new
  end

  def create
    @session = current_user
    @health_metric = current_user.health_metrics.new(health_metric_params)

    if @health_metric.save
      redirect_to @health_metric, notice: 'Health metric was successfully created.'
    else
      flash.now[:alert] = @health_metric.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @session = current_user
    @health_metric = current_user.health_metrics.find(params[:id])
  end

  def update
    @session = current_user
    @health_metric = current_user.health_metrics.find(params[:id])

    if @health_metric.update(health_metric_params)
      redirect_to @health_metric, notice: 'Health metric was successfully updated.'
    else
      flash.now[:alert] = @health_metric.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @session = current_user
    @health_metric = current_user.health_metrics.find(params[:id])

    if current_user.admin? || current_user.trainer? || current_user.id == @health_metric.user_id
      @health_metric.destroy
      redirect_to root_path, notice: 'Health metric was successfully deleted.'
    else
      flash.now[:alert] = @health_metric.errors.full_messages.to_sentence
      render :show, status: :unprocessable_entity
    end
  end

  private

  def health_metric_params
    params.require(:health_metric).permit(:height, :weight, :hydration, :muscle_mass, :caloric_intake, :caloric_burn, :steps, :sleep_quality, :resting_heart_rate)
  end
end
