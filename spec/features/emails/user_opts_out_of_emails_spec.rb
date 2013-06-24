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
    SummaryDispatcher::WeeklySummary.send_weekly_summary
    expect(last_email).to be_nil
  end

  scenario 'user opts out of receiving daily email' do
    uncheck 'Receive daily email summary?'
    fill_in 'user_current_password', with: user1.password
    click_button 'Update'
    expect(user1.reload.receives_daily_email).to be_false
    reset_email
    SummaryDispatcher::DailySummary.send_daily_summary
    expect(last_email).to be_nil
  end

  scenario 'user uses unsubscribe link in daily summary to opt out of emails' do
    sign_out user1
    UserMailer.daily_summary(user1).deliver
    open_last_email_for(user1.email)
    visit_in_email 'Unsubscribe'
    expect(current_path).to eql(new_user_session_path)
    fill_in 'user_email', with: user1.email
    fill_in 'user_password', with: user1.password
    click_button 'Sign in'
    expect(current_path).to eql(edit_user_registration_path)
  end

  scenario 'user uses unsubscribe link in weekly summary to opt out of emails' do
    sign_out user1
    UserMailer.weekly_summary(user1).deliver
    open_last_email_for(user1.email)
    visit_in_email 'Unsubscribe'
    expect(current_path).to eql(new_user_session_path)
    fill_in 'user_email', with: user1.email
    fill_in 'user_password', with: user1.password
    click_button 'Sign in'
    expect(current_path).to eql(edit_user_registration_path)
  end

end
