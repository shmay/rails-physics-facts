class Api::UsersController < Api::ApplicationController

  def current
    render json: @current_user, UserSerializer
  end
end
