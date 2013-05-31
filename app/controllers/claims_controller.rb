class ClaimsController < ApplicationController

  def index
    @claim = Claim.new
    set_up_search_results
    @claim_balance = ClaimBalance.new(current_user, @claims)
  end

  def show
    @comment = Comment.new
    @claim = Claim.find(params[:id])
    @comments = @claim.comments
  end

  def create
    current_user.group.users.each do |other|
      if params[other.name]
        @claim = Claim.new(params[:claim])
        @claim.user_who_owes = other
        @claim.user_owed_to = current_user
        if !@claim.save
          set_up_search_results
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
    @claim.update_attributes(paid: true)
    redirect_to claims_path
  end

  private

  def set_up_search_results
    @search = current_user.claims.search(params[:q])
    @claims = @search.result
    # if params[:q]
    #   @search = Claim.search(params[:q])
    #   @claims = @search.result
    # else
    #   @search = current_user.claims.search(params[:q])
    #   @claims = @search.result
    # end
  end

end
