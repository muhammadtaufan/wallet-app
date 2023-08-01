class Api::V1::ApplicationController < ActionController::API
  before_action :authenticate_user
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def authenticate_user
    token = auth_token
    @current_user = User.find_by(token: token)

    render json: { error: 'Not authenticated or invalid token' }, status: :unauthorized unless @current_user
  end

  def record_not_found
    render json: { error: 'Record not found' }, status: :not_found
  end

  def auth_token
    auth_header = request.headers['Authorization']
    if auth_header
      auth_header.split(' ').last
    else
      render json: { error: 'Missing Authorization header' }, status: :unauthorized
    end
  end
end
