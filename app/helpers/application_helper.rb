module ApplicationHelper

  def other_users
    users = []
    current_user.group.users.each do |u|
      users << u unless u.id == current_user.id
    end
    users
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => direction)
  end

  def sort_column
    params[:sort] || "created_at"
  end

  def sort_direction
    params[:direction] || "desc"
  end

end
