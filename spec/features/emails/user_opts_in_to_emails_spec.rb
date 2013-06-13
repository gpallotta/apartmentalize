require 'spec_helper'

feature 'User opts in to emails', %{
  As a user
  I want to opt in to receive emails from the site
  so I can receive reminders
} do

  let(:user1) { FactoryGirl.create(:user) }
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  before(:each) do
    sign_in user1
    visit user_path(user1)
    click_link 'Edit'
  end

  scenario 'user opts in to weekly email' do
    check 'Receive weekly email summary?'
    fill_in 'user_current_password', with: user1.password
    click_button 'Update'
    expect(user1.reload.receives_weekly_email).to be_true
    UserMailer.send_weekly_summary
    expect(last_email).to deliver_to(user1.email)
    expect(last_email).to have_subject('Apartment - Weekly Summary')
  end

  scenario 'user opts in to daily email' do
    check 'Receive daily email summary?'
    fill_in 'user_current_password', with: user1.password
    click_button 'Update'
    expect(user1.reload.receives_daily_email).to be_true
    UserMailer.send_daily_summary
    expect(last_email).to deliver_to(user1.email)
    expect(last_email).to have_subject('Apartment - Daily Summary')
  end

end
