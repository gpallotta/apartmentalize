class FrontPageController < ApplicationController

  before_filter :redirect_if_authenticated, only: [:welcome]
  before_filter :authenticate_user!, only: [:home]

  def home
    @balances = ClaimBalance.new(current_user, current_user.unpaid_claims).user_balances
    @activities = current_user.activities_as_recipient.order("created_at DESC").limit(10)
  end

  def welcome
  end

  def about
  end

end
