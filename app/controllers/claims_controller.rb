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
    @created_claims = []
    all_valid = true

    current_user.group.users.each do |other|
      if params[other.name]
        @claim = Claim.new(params[:claim])
        @claim.user_who_owes = other
        @claim.user_owed_to = current_user
        if !@claim.save
          all_valid = false
        else
          @created_claims << @claim
        end
      end
    end

    respond_to do |format|
      if all_valid
        format.js
        format.html { redirect_to claims_path }
      else
        format.html do
          set_up_search_results
          @claim_balance = ClaimBalance.new(current_user, @claims)
          render 'index'
        end
        format.js { render 'claim_errors' }
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
