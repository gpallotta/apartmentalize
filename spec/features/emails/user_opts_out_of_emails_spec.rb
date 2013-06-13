require 'spec_helper'

feature 'User opts out of emails', %{
  As a user
  I want to be able to opt out of receiving emails
  so I don't feel like I'm being spammed
} do

  let(:user1) { FactoryGirl.create(:user, receives_weekly_email: false) }
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  scenario 'user opts out of receiving weekly email' do
    sign_in user1
    visit user_path(user1)
    click_link 'Edit'
    uncheck 'Receive weekly email summary?'
    fill_in 'user_current_password', with: user1.password
    click_button 'Update'
    expect(user1.reload.receives_weekly_email).to be_false
    UserMailer.weekly_summary.deliver
    expect(last_email).not_to deliver_to(user1.email)
  end

end
