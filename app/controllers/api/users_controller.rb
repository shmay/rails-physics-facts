class Api::UsersController < Api::ApplicationController

  def current
    render json: {}, UserSerializer
  end
end
