module SessionsHelper

  def set_current_group_id_before_login(id)
    cookies[:current_group_id] = id
  end

  def current_group=(group)
    @current_group = group
  end

  def current_group
    @current_group ||= Group.find(cookies[:current_group_id])
  end

end
