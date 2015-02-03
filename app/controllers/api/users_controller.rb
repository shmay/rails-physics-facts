class Api::UsersController < Api::ApplicationController
  def current
    render json: current_user, serializer:UserSerializer
  end
end
