include ApplicationHelper

def fill_in_registration_forms
  fill_in 'user_name', with: 'Valid name'
  fill_in 'user_email', with: 'valid@email.com'
  fill_in 'user_password', with: '12345678'
  fill_in 'user_password_confirmation', with: '12345678'
end
