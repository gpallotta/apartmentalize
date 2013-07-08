include ApplicationHelper

def sign_in(user)
  visit welcome_page_path
  fill_in 'user_email', with: user.email
  fill_in 'user_password', with: user.password
  click_button 'Sign in'
end

def sign_out(user)
  click_link 'Sign out'
end
