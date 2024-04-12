class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.admin? || current_user.trainer?
      @users = User.all
    else
      @users = [current_user]
    end
  end
end
