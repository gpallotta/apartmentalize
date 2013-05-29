class ApplicationController < ActionController::Base
  layout :user_authorized
  protect_from_forgery
  include SessionsHelper

  private

  def user_authorized
    user_signed_in? ? 'authorized' : 'unauthorized'
  end

end
