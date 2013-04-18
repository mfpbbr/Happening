class UsersController < ApplicationController
  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    begin
      @user = User.find(params[:id])
    rescue
      flash[:error] = "Requested user does not exist"
      redirect_to current_user
    end
  end
end
