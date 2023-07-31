class Api::V1::ApplicationController < ActionController::API
  before_action :authenticate_user

  private

  def authenticate_user
    @current_user = User.find_by(id: session[:user_id])
    render json: { status: 'error', message: 'Not signed in' }, status: :unauthorized unless @current_user
  end
end
