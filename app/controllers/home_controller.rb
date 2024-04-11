class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @session = current_user
    @users = User.all
  end
end
