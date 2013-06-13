require 'spec_helper'

feature 'User opts in to emails', %{
  As a user
  I want to opt in to receive emails from the site
  so I can receive reminders
} do

  let(:user1) { FactoryGirl.create(:user) }
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  scenario 'user opts in to weekly email' do
    sign_in user1
    visit user_path(user1)
    click_link 'Edit'
    check 'Receive weekly email summary?'
    fill_in 'user_current_password', with: user1.password
    click_button 'Update'
    expect(user1.reload.receives_weekly_email).to be_true
    User.send_weekly_summary
    expect(last_email).to deliver_to(user1.email)
    expect(last_email).to have_subject('Apartment - Weekly Summary')
  end

  scenario 'user opts in to daily email'

end
