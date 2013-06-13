require 'spec_helper'

feature 'User opts out of emails', %{
  As a user
  I want to be able to opt out of receiving emails
  so I don't feel like I'm being spammed
} do

  let(:user1) { FactoryGirl.create(:user, receives_weekly_email: true,
                  receives_daily_email: true) }
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  before(:each) do
    sign_in user1
    visit user_path(user1)
    click_link 'Edit'
  end

  scenario 'user opts out of receiving weekly email' do
    uncheck 'Receive weekly email summary?'
    fill_in 'user_current_password', with: user1.password
    click_button 'Update'
    expect(user1.reload.receives_weekly_email).to be_false
    reset_email
    UserMailer.send_weekly_summary.deliver
    expect(last_email).to be_nil
  end

  scenario 'user opts out of receiving daily email' do
    uncheck 'Receive daily email summary?'
    fill_in 'user_current_password', with: user1.password
    click_button 'Update'
    expect(user1.reload.receives_daily_email).to be_false
    reset_email
    UserMailer.send_daily_summary.deliver
    expect(last_email).to be_nil
  end

end
