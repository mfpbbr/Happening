class LikesController < ApplicationController
  def create
    @likeable = find_likeable
    @like = @likeable.likes.build
    @like.user_id = current_user.id
    if @like.save
      flash[:success] = "like action was successful"
    else
      flash[:error] = "error in doing the like action"
    end

    redirect_to :back
  end

  def destroy
    begin
      @like = current_user.likes.find(params[:id])
      @like.destroy
      flash[:success] = "undo like action was successful"
    rescue
      flash[:error] = "error in undoing the like action"
    end

    redirect_to :back
  end  
end
