module ApplicationHelper

  def other_users user
    users = []
    user.group.users.each do |u|
      users << u unless u.id == user.id
    end
    users
  end

  def parse_time time
    time.strftime("%B %d, %Y")
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = (column == sort_column) ? "current #{sort_direction}" : nil
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => direction), { :class => css_class}
  end

  def sort_column
    params[:sort] || "created_at"
  end

  def sort_direction
    params[:direction] || "desc"
  end

  def title(page_title)
    content_for :title, page_title.to_s
  end

end
