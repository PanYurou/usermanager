class Api::V1::UsersController < ApplicationController
  before_action :get_user, only: [:update_user, :delete_user, :show_user]

  def get_users
    users = User.all
    if users
      render json: users, status: :ok
    else
      render json: {msg: 'users empty'}, status: :unprocessable_entity
    end
  end

  #add
  def add_user
    user = User.new(user_params)
    user.type = 2
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
        render json: @user, status: :ok
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
    params.permit(:username, :email, :password)
  end

  def get_user
    @user = User.find(params[:id])
  end
end
