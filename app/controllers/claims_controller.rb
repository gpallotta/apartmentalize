class ClaimsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :authorize_claim_collaborator, :only => [:show]

  respond_to :json, :html

  def index
    @claim = Claim.new
    set_up_search_results
    @claim_balance = ClaimBalance.new(current_user, @claims)
    decorate_and_paginate_claims
  end

  def show
    @comment = Comment.new
    @comments = @claim.comments.oldest_first
    @comments_count = @comments.count
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
          decorate_and_paginate_claims
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

  def decorate_and_paginate_claims
    @claims = PaginatingDecorator.decorate(Kaminari.paginate_array(@claims).
          page(params[:page]))
  end

  def track_activity_for_claim_creation
    @claim_creator.created_claims.each do |c|
      track_activity( c, recipient_for_activity(c) )
    end
  end

  def set_up_search_results
    @search = ClaimSearch.new(current_user, params)
    if params[:z]
      @claims = @search.search
    else
      params[:z] = {user_id: {}}
      @claims = current_user.unpaid_claims
    end
    params[:z][:user_id] = {} if !params[:z][:user_id] # fix this
    sort_claims
  end

  def sort_claims
    if params[:sort] == 'owed_by'
      # @claims = @claims.joins("INNER JOIN users on users.id = claims.user_who_owes_id").
      # order("users.name #{sort_direction}")
      @claims = @claims.joins(:user_who_owes).order("users.name #{sort_direction}")
    elsif params[:sort] == 'owed_to'
      @claims = @claims.joins(:user_owed_to).order("users.name #{sort_direction}")
    else
      @claims = @claims.order("#{sort_column} #{sort_direction}")
    end
  end

  def sort_column
    Claim.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

  def authorize_claim_collaborator
    @claim = Claim.find(params[:id]).decorate
    if !@claim.involves?(current_user)
      redirect_to claims_path
    end
  end

end
