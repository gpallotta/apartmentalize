class FrontPageController < ApplicationController

  before_filter :redirect_if_authenticated, only: [:welcome]
  before_filter :authenticate_user!, only: [:home, :help]

  def home
    c = ClaimBalance.new(current_user, current_user.unpaid_claims)
    @balances = c.user_balances
    @total = c.total
    @activities = current_user.activities_as_recipient.order("created_at DESC").limit(10)
  end

  def welcome
  end

  def about
  end

  def help
  end

end
