class Api::V1::UsersController < ApplicationController
  before_action :get_user, only: %i[update_user delete_user show_user]
  before_action only: %i[update_user delete_user] do
    check_token(2)
  end

  before_action only: [:show_user] do
    check_token(1, true)
  end

  def get_users
    users = User.all.map do |u|
      u.as_json(except: %i[password_digest _id token]
      ).merge({id: u._id.to_s})
    end
    if users
      render json: users, status: :ok
    else
      render json: {msg: 'users empty'}, status: :unprocessable_entity
    end
  end

  #add
  def add_user
    user = User.new(user_params)
    if user.save
      render json: user, status: :ok
    else
      render json: {message: 'user not add ', errors: user.errors}, status: :unprocessable_entity
    end
  end

  #update
  def update_user
    if @user
      if @user.update(user_params)
        render json: @user.as_json(except: [:password_digest]), status: :ok
      else
        render json: {msg: 'Updated failed', errors: @user.errors}, status: :unprocessable_entity
      end
    else
      render json: {msg: 'User not find'}, status: :unprocessable_entity
    end
  end

  #destory
  def delete_user
    if @user
      if @user.destroy
        render json: {msg: 'User deleted'}, status: :ok
      else
        render json: {msg: 'deleted failed'}, status: :unprocessable_entity
      end
    else
      render json: {msg: 'User not find'}, status: :unprocessable_entity
    end
  end

  # show
  def show_user
    if @user
      render json: @user, status: :ok
    else
      render json: {message: 'User not find'}, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:username, :email, :password, :type)
  end

  def get_user
    @user = User.find(params[:id])
  end
end
