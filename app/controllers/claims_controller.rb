class ClaimsController < ApplicationController

  def index
    @claim = Claim.new
    set_up_search_results
    @claim_balance = ClaimBalance.new(current_user, @claims)
  end

  def show
    @comment = Comment.new
    @claim = Claim.find(params[:id])
    @comments = @claim.comments.oldest_first
  end

  def create
    @claim_creator = ClaimCreator.new(current_user, params)
    @claim_creator.create_claims

    respond_to do |format|
      if @claim_creator.all_valid
        format.js
        format.html { redirect_to claims_path }
      else
        @claim = Claim.new
        format.js { render 'claim_errors' }
        format.html do
          set_up_search_results
          @claim_balance = ClaimBalance.new(current_user, @claims)
          render 'index'
        end
      end
    end

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
    respond_to do |format|
      format.js { render 'index' }
      format.html { redirect_to :back }
    end
  end


  private

  def set_up_search_results
    @unfiltered_claims = current_user.claims
    @search = ClaimSearch.new(current_user, @unfiltered_claims, params)
    @claims = @search.results
  end

end
