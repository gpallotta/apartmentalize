require 'spec_helper'

feature 'User receives invitation', %q{
  As a user who has yet to sign up
  I want to receive an invitation to the site
  so that I can automatically link up with my roommates
} do

include EmailSpec::Helpers
include EmailSpec::Matchers

  # AC
  # I receive an email sent by my roommate to the specific email
  # When I click a link in the email, I am automatically associated with my roommates
  # I can specify a name and password after I click the link

  given(:inviter) { FactoryGirl.create(:user) }
  given(:email) { 'room@room.com'}

  before do
    sign_in inviter
    visit new_user_invitation_path
    fill_in 'Email', with: email
    fill_in 'Name', with: 'roommate'
    click_button 'Send an invitation'
    expect(User.last.group).to eql(inviter.group)
    sign_out inviter
  end

  scenario 'user accepts invitation' do
    password = 'password'
    open_last_email_for(email)
    visit_in_email 'Accept invitation'
    fill_in 'Name', with: 'Updated'
    fill_in 'Password', with: password
    fill_in 'Password confirmation', with: password
    click_button 'Create'
    expect(User.last.name).to eql('Updated')
  end

end

