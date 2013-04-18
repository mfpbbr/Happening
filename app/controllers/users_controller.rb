class UsersController < ApplicationController
  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.where(id: params[:id]).first
    @feed_items = @user.nil? ? [] : @user.activity
  end
end
