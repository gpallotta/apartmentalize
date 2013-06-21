class ApplicationController < ActionController::Base

  layout :user_authorized
  protect_from_forgery
  include SessionsHelper

  def after_invite_path_for user
    user_path(current_user)
  end

  private

  def redirect_if_authenticated
    if user_signed_in?
      redirect_to home_page_path
    end
  end

  def user_authorized
    user_signed_in? ? 'authorized' : 'unauthorized'
  end

  def track_activity(trackable, recipient, action = params[:action])
    activity = current_user.activities_as_owner.build(action: action, trackable: trackable)
    activity.recipient = recipient
    activity.save
  end

  def recipient_for_activity obj
    # the recipient is the other user in regards to the object
    if obj.user_owed_to.id == current_user.id
      obj.user_who_owes
    else
      obj.user_owed_to
    end
  end

end
