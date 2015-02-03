class Api::UsersController < Api::ApplicationController
  def blah
    render :json => current_user, UserSerializer
  end
end
