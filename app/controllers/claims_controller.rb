class ClaimsController < ApplicationController

  def index
    @claim = Claim.new
    @claims = current_user.claims
    @search = ClaimSearch.new(current_user, @claims, params)
    @claims = @search.results
    @claim_balance = ClaimBalance.new(current_user, @claims)
  end

  def show
    @comment = Comment.new
    @claim = Claim.find(params[:id])
    @comments = @claim.comments.oldest_first
  end

  def create
    current_user.group.users.each do |other|
      if params[other.name]
        @claim = Claim.new(params[:claim])
        @claim.user_who_owes = other
        @claim.user_owed_to = current_user
        if !@claim.save
          @claims = current_user.claims
          @claim_balance = ClaimBalance.new(current_user, @claims)
          render 'index'
          return
        end
      end
    end
    redirect_to claims_path
  end

  def edit
    @claim = Claim.find(params[:id])
  end

  def update
    @claim = Claim.find(params[:id])
    if @claim.update_attributes(params[:claim])
      redirect_to claim_path(@claim)
    else
      render 'edit'
    end
  end

  def destroy
    @claim = Claim.find(params[:id])
    @claim.destroy
    redirect_to claims_path
  end

  def mark_as_paid
    @claim = Claim.find(params[:id])
    @claim.mark_as_paid
    redirect_to :back
  end

end
