class InvitationsController < Devise::InvitationsController

  def create
    resource_params[:group_id] = current_user.group.id
    super
  end

end
