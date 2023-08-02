class Api::V1::ApplicationController < ActionController::API
  before_action :authenticate_user
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ArgumentError, with: :handle_argument_error
  rescue_from StandardError, with: :handle_standard_error

  private

  def authenticate_user
    token = auth_token
    @current_user = User.find_by(token: token)

    unless @current_user
      render json: { status: 'error', message: 'Not authenticated or invalid token' },
             status: :unauthorized
    end
  end

  def record_not_found
    render json: { status: 'error', message: 'Record not found' }, status: :not_found
  end

  def auth_token
    auth_header = request.headers['Authorization']
    if auth_header
      auth_header.split(' ').last
    else
      render json: { status: 'error', message: 'Missing Authorization header' }, status: :unauthorized
    end
  end

  def handle_argument_error(e)
    render json: { status: 'error', message: e.message }, status: :bad_request
  end

  def handle_standard_error(_e)
    render json: { status: 'error', message: 'Failed to fetch the stock price' }, status: :internal_server_error
  end
end
