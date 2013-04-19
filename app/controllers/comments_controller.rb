class CommentsController < ApplicationController
  before_filter :correct_user, only: :destroy

  def create
    @commentable = find_polymorphic_parent_entity
    @comment = @commentable.comments.build(params[:comment])
    @comment.user_id = current_user.id
    unless @comment.save
      flash[:error] = "error in doing the comment action"
    end 

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end 
  end 

  def destroy
    @comment.destroy
    @commentable = @comment.commentable

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  def show
    @comment = Comment.where(id: params[:id]).first
    redirect_to root_url if @comment.nil?
  end

  private

    def correct_user
      @comment = current_user.comments.where(id: params[:id]).first
      redirect_to root_url if @comment.nil?
    end
end

