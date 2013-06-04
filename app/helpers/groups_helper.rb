module GroupsHelper

  # user for generating red border around identifier lookup input
  def form_error err
    return 'form-error' if err
    return ''
  end

end
