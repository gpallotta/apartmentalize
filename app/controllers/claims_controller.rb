class ClaimsController < ApplicationController

  def index
    @claim = Claim.new
    set_up_search_results
  end

  def show
    @comment = Comment.new
    @claim = Claim.find(params[:id])
  end

  def create
    current_user.group.users.each do |other|
      if params[other.name]
        @claim = Claim.new(params[:claim])
        @claim.user_who_owes = other
        @claim.user_owed_to = current_user
        if !@claim.save
          set_up_search_results
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
    # if !params[:q]
    #   @claims = @claims.where(:paid => false)
    # end
    # @totals = dont_do_this @claims
    # @totals = ClaimCounter.new(@claims, current_user)
  end

  # def dont_do_this claims
  #   answer = {}
  #   answer.default = 0
  #   claims.each do |c|
  #     if c.user_owed_to == current_user
  #       answer[c.user_who_owes.name] += c.amount
  #     else
  #       answer[c.user_owed_to.name] -= c.amount
  #     end
  #   end
  #   answer[:total] = answer.values.inject(:+)
  #   answer
  # end

end
