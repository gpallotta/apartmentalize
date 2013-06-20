class ClaimsController < ApplicationController

  before_filter :authenticate_user!

  respond_to :json, :html

  def index
    @claim = Claim.new
    set_up_search_results
    @claim_balance = ClaimBalance.new(current_user, @claims)
    @claims = Kaminari.paginate_array(@claims).page(params[:page])
  end

  def show
    @comment = Comment.new
    @claim = Claim.find(params[:id])
    if user_related_to_claim?(@claim)
      @comments = @claim.comments.oldest_first
      @comments_count = @comments.count
    else
      redirect_to claims_path
    end
  end

  def create
    @claim_creator = ClaimCreator.new(current_user, params)
    @claim_creator.create_claims

    respond_to do |format|
      if @claim_creator.all_valid
        track_activity_for_claim_creation
        format.json { render :json => @claim_creator.created_claims }
        format.html { redirect_to claims_path }
      else
        @claim = Claim.new
        format.json
        format.html do
          set_up_search_results
          @claim_balance = ClaimBalance.new(current_user, @claims)
          @claims = Kaminari.paginate_array(@claims).page(params[:page])
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
      track_activity( @claim, recipient_for_activity(@claim) )
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
    track_activity @claim, recipient_for_activity(@claim)
    respond_to do |format|
      format.json { render :json => @claim }
      format.html { redirect_to :back }
    end
  end


  private

  def track_activity_for_claim_creation
    @claim_creator.created_claims.each do |c|
      track_activity( c, recipient_for_activity(c) )
    end
  end

  def set_up_search_results
    @unfiltered_claims = current_user.claims
    @search = ClaimSearch.new(current_user, @unfiltered_claims, params)
    @claims = @search.results
  end

  def user_related_to_claim? claim
    if claim.user_who_owes == current_user || claim.user_owed_to == current_user
      true
    else
      false
    end
  end

end
