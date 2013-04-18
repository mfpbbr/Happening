class RelationshipsController < ApplicationController
  def create
    @user = User.where(id: params[:relationship][:followed_id]).first
    current_user.follow!(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    followed_id = Relationship.where(id: params[:id]).first.followed_id
    @user = User.where(id: followed_id).first
    current_user.unfollow!(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end
