class FrontPageController < ApplicationController

  before_filter :redirect_if_authenticated, only: [:welcome]

  def home
    if user_signed_in?
      @balances = ClaimBalance.new(current_user, current_user.claims).user_balances
      @activities = current_user.activities_as_recipient.order("created_at DESC").limit(10)
    else
      redirect_to welcome_page_path
    end
  end

  def welcome
  end

end
