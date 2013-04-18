class LikesController < ApplicationController
  before_filter :correct_user, only: :destroy

  def create
    @likeable = find_polymorphic_parent_entity
    @like = @likeable.likes.build
    @like.user_id = current_user.id
    unless @like.save
      flash[:error] = "error in doing the like action"
    end

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  def destroy
    @like.destroy
    @likeable = @like.likeable

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end 

  private

    def correct_user
      @like = current_user.likes.where(id: params[:id]).first
      redirect_to root_url if @like.nil? 
    end 
end
