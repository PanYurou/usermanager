# frozen_string_literal: true

require 'TokenManager'

class ApplicationController < ActionController::API
  include TokenManager

  def create_token(user_id, user_name, user_type)
    generate_token(user_id, user_name, user_type)
  end

  def check_auth(return_user = false)
    user_token = decrypt_token request.headers['token']
    if token
      # token 过期
      if user_token[:ex_time] < Time.now
        render json: {msg: 'Token Expired'}, status: :unauthorized
      else
        user = User.find_by user_token[:user_id]
        if user
          render json: {msg: 'User Unauthorized'}, status: :ok if return_user
          return true
        else
          render json: {msg: 'not Unauthorized'}, status: :unauthorized
        end
      end
    else
      render json: {msg: 'Unauthorized,Token Unacceptable'}, status: :unauthorized
    end
  end
end
