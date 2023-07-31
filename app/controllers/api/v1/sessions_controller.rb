class Api::V1::SessionsController < Api::V1::ApplicationController
  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      render json: { status: 'OK', message: 'Sign in successful' }
    else
      render json: { status: 'error', message: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def destroy
    session.delete(:user_id)
    render json: { status: 'OK', message: 'Sign out successful' }
  end
end
