class ApplicationController < ActionController::Base
  layout :user_authorized
  protect_from_forgery
  include SessionsHelper

  def set_up_search_results
    @search = Claim.search(params[:q])
    @claims = @search.result
    @claims = @claims.where(:paid => false) unless params[:include_paid]
  end

  private

  def user_authorized
    user_signed_in? ? 'authorized' : 'unauthorized'
  end

end
