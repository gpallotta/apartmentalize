module ApplicationHelper

  def other_users
    users = []
    current_user.group.users.each do |u|
      users << u unless u.id == current_user.id
    end
    users
  end

end
