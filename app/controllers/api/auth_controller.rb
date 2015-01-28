require 'byebug'
class Api::AuthController < Api::ApplicationController

  def sign_in
    user = User.find_by(email: params[:user][:email].downcase)

    if user && user.authenticate(params[:user][:password])
      log_in user

      render :json => {
         :user => current_user,
         :status => :ok
       }
      # Log the user in and redirect to the user's show page.
    else
       render :json => {}.to_json, :status => :unprocessable_entity
      # Create an error message.
    end
  end

  def sign_out
    log_out if logged_in?

    render json: {status: :ok}
  end

  def sign_up
  end

  def get_current_user
    render json: current_user, serializer: UserSerializer
  end
end
