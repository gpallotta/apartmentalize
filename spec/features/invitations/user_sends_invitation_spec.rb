require 'spec_helper'

feature 'sending an invitation to the site', %q{
  As a user signing up
  I want to be able to send an invitation to the site to my roommates
  so that I can streamline the joining process
} do

  # AC:
  # I can send an email to my roommates inviting them to join the site
  # They are automatically linked up to my group

  given(:user) { FactoryGirl.create(:user) }

  before do
    sign_in user
    visit user_path(user)
    click_link 'Send an invitation'
  end

  scenario 'user sends valid invitation' do
    fill_in 'Name', with: 'Cool dude'
    fill_in 'Email', with: 'email@email.com'
    before_count = User.count
    click_button 'Send an invitation'
    expect(User.count).to eql(before_count+1)
    expect(current_path).to eql( user_path(user) )
  end

  scenario 'user sends invalid invitation' do
    before_count = User.count
    click_button 'Send an invitation'
    expect(User.count).to eql(before_count)
    expect(page).to have_content("can't be blank")
  end

end
