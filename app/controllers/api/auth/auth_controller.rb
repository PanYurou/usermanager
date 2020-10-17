class Api::Auth::AuthController < ApplicationController
  def login
    user = User.find_by username: params[:username]

    unless user
      render json: {msg: 'username not exist'}, status: :unprocessable_entity
      return true
    end

    if user
      if user.authenticate(params[:password])
        token = create_token(user.id, user.username, user.type.to_s)
        user.set token: token
        render json: {msg: 'sucessful login',
                      user: user.as_json(except: [:password_digest])}, status: :ok
      else
        render json: {msg: 'password wrong'}, status: :unprocessable_entity
      end
    end
  end
end
