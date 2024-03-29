class Api::V1::ApplicationController < ActionController::API
  before_action :authenticate_user
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  rescue_from ArgumentError, with: :handle_argument_error
  rescue_from StandardError, with: :handle_standard_error

  private

  def authenticate_user
    unless @current_user
      render json: { status: 'error', message: 'Not authenticated or invalid token' },
             status: :unauthorized
    end
  end

  def current_user
    @current_user ||= User.find_by(token: auth_token)
  end

  def record_not_found
    render json: { status: 'error', message: 'Record not found' }, status: :not_found
  end

  def record_invalid
    render json: { status: 'error', message: 'Something is wrong. Please try again later.' },
           status: :unprocessable_entity
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
    render json: { status: 'error', message: 'Something is wrong. Please try again later.' },
           status: :internal_server_error
  end
end
