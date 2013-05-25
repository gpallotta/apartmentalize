module SessionsHelper

  def set_current_group_before_login(group)
    cookies.permanent[:current_group] = group.identifier
  end

  def current_group=(group)
    @current_group = group
  end

  def current_group
    @current_group ||= Group.find_by_identifier(cookies[:current_group])
  end

end
