require 'spec_helper'

feature 'user sends a payment', %q{
  As a user
  I want to be able to pay my owed claims through the site
  so I can do everything in one place
} do

  given(:user) { FactoryGirl.create(:user)}

  scenario 'user sends payment successfully' do
    sign_in user
    visit claims_path
    click_link 'Pay'
  end

end
