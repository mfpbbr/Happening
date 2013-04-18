class StatusesController < ApplicationController
  def create
    @status = current_user.statuses.build(params[:status])
    @status.coordinates = current_geo_location
    if @status.save
      flash[:success] = "Successfully updated status"
    else
      flash[:error] = "Error in updating status"
    end 

    redirect_to user_path(params[:user_id])

  end

  def destroy
    @status = current_user.statuses.where(id: params[:id]).first
    if @status.nil?
      flash[:error] = "Unable to delete the status"
    else
      @status.destroy
    end

    redirect_to user_path(current_user)
  end

  def show
    @status = Status.where(id: params[:id]).first
    if @status.nil?
      flash[:error] = "No such status exists"
      redirect_to root_path
    end
  end
end
