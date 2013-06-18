class InvitationsController < Devise::InvitationsController

  def create
    resource_params[:group_id] = current_user.group_id
    super
  end

end
