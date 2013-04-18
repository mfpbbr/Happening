class UsersController < ApplicationController
  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.where(id: params[:id]).first
    @feed_items = @user.nil? ? [] : @user.activity
  end

  def following
    @title = "Following"
    @user = User.where(id: params[:id]).first
    @users = @user.followed_users
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.where(id: params[:id]).first
    @users = @user.followers
    render 'show_follow'
  end
end
