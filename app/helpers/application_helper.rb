module ApplicationHelper

  def other_users
    users = []
    current_user.group.users.each do |u|
      Rails.logger.debug "othername #{u.name}"
      users << u unless u.id == current_user.id
    end
    users
  end

end
