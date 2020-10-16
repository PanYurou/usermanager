class Api::Auth::AuthController < ApplicationController
  def login
    user = User.find_by username: params[:username]

    unless user
      render json: {msg: 'username not exist'}, status: :unprocessable_entity
      return true
    end

    if user
      if user.authenticate(params[:password])
        render json: {msg: 'sucessful login', user: user}, status: :ok
      else
        render json: {msg: 'password wrong'}, status: :unprocessable_entity
      end
    end
  end
end
