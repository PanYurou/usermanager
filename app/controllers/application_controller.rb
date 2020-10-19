# frozen_string_literal: true

require 'TokenManager'

class ApplicationController < ActionController::API
  include TokenManager

  def create_token(user_id, user_name, user_type)
    generate_token(user_id, user_name, user_type)
  end

  def check_token(user_type = 1, return_user = false, forCheckingOnly = false)
    user_token = decrypt_token request.headers['token']
    if user_token
      # token 过期
      if user_token[:token_ex].to_i < Time.now.to_i && !forCheckingOnly
        render json: {msg: 'Token Expired'}, status: :unauthorized
      else
        user = User.find user_token[:user_id]
        if user[:type].to_i != user_type && !forCheckingOnly
          render json: {msg: 'Unauthorized You type is not 1'}, status: :unauthorized
          return false
        end

        if user
          render json: user, status: :ok if return_user
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
