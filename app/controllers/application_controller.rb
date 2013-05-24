class ApplicationController < ActionController::Base
  layout :user_authorized
  protect_from_forgery

  private

  def user_authorized
    user_signed_in? ? 'authorized' : 'unauthorized'
  end

end
