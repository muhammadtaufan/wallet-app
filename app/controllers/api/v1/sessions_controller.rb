class Api::V1::SessionsController < Api::V1::ApplicationController
  skip_before_action :authenticate_user, only: [:create]

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      user.generate_token
      user.save!
      render json: { status: 'success', message: 'Sign in successful', token: user.token }
    else
      render json: { status: 'error', message: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def destroy
    @current_user.invalidate_auth_token
    render json: { status: 'success', message: 'Sign out successful' }
  end
end
