# frozen_string_literal: true

class Api::V1::AuthController < ApplicationController
  before_action :authorize_request, except: :login

  # POST /auth/login
  def login
    user = User.find_by_email(params[:email])
    if user&.authenticate(params[:password])
      create_token user
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  # POST /auth/login
  def refresh
    create_token current_user
  end

  private

  def create_token(user)
    time = Time.now + 24.hours.to_i
    token = JsonWebToken.encode({ user_id: user.id }, time)
    render json: {
      token: token,
      exp: time.to_datetime.rfc3339,
      user: user.as_json(except: [:password_digest])
    }, status: :created
  end

  def login_params
    params.permit(:email, :password)
  end
end
