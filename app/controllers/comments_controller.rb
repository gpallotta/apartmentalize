class CommentsController < ApplicationController

  respond_to :json

  def create
    @comment = current_user.comments.new(params[:comment])
    @claim = @comment.claim

    if @comment.save
      track_activity @comment, recipient_for_activity(@claim)
      # format.json { render :json => @comment.to_json }
      # format.html { render @comment }
      respond_with( @comment )
    else
      # format.json {
      #   :content => 'error'
      # }
    end

  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.update_attributes(params[:comment])
      redirect_to claim_path(@comment.claim.id)
    else
      render 'edit'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    claim_id = @comment.claim.id
    @comment.destroy
    redirect_to claim_path(claim_id)
  end

end
