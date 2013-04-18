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
    begin
      @status = current_user.statuses.find(params[:id])
      @status.destroy
    rescue
      flash[:error] = "Unable to delete the status"
    end

    redirect_to user_path(current_user)
  end

end
