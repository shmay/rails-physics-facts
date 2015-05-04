class Api::ApplicationController < ActionController::Base
  include AuthHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  skip_before_action :verify_authenticity_token

  protected

    def logged_in_user
      unless logged_in?
        render json: {error: "Need to be logged in to complete this task"}, status: :unprocessable_entity
      end
    end
end
