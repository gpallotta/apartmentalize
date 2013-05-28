include ApplicationHelper

def fill_in_registration_forms
  fill_in 'user_name', with: 'Valid name'
  fill_in 'user_email', with: 'valid@email.com'
  fill_in 'user_password', with: '12345678'
  fill_in 'user_password_confirmation', with: '12345678'
end

def sign_in(user)
  visit root_path
  fill_in 'user_email', with: user.email
  fill_in 'user_password', with: user.password
  click_button 'Sign in'
end
