class Api::V1::UsersController < ApplicationController

  def get_users

  end

  def add_user
    user = User.new(username: params[:username], email: params[:email], password_digest:
        params[:password])
    if user.save
      render json: user, status: :ok
    else
      render json: {message: 'user not add '}, status: :unprocessable_entity
    end
  end
end
