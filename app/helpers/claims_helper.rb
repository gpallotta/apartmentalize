module ClaimsHelper

  def user_checkbox_checked? name, search
    if search.checked_users && search.checked_users.include?(name)
      true
    end
  end

end
