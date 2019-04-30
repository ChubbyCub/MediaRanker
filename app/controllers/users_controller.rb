class UsersController < ApplicationController
  def login_form
    @user = User.new
  end

  def login
    username = params[:user][:username]
    user = User.find_by(username: username)

    if user.nil?
      user = User.create(username: username)
    else
      session[:user_id] = user.id
      flash[:alert] = "Welcome back #{user.username}!"
      redirect_to root_path
      return
    end

    if user.id
      session[:user_id] = user.id
      flash[:alert] = "#{user.username} logged in as a new user"
      redirect_to root_path
    else
      user.errors.messages.each do |field, messages|
        flash[field] = messages
      end
      redirect_back(fallback_location: root_path)
    end
  end

  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])

    if @user.nil?
      flash[:error] = "Invalid user"
      redirect_to root_path
    end
  end

  def logout
    session[:user_id] = nil
    flash[:success] = "Successfully logged out"
    redirect_to root_path
  end

  private

  def user_params
    return params.require(:user).permit(:username, vote_ids: [])
  end
end
