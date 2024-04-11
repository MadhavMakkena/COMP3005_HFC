class ApplicationController < ActionController::Base
  include Authentication
  add_flash_types :info, :error, :success
end
