require 'spec_helper'

feature 'User sends invitation', %q{
  As a user signing up
  I want to be able to invite my roommates after I sign up
  so I can invite then to use the site with me
} do

# AC:
# I am taken to a page where I can enter my roommates emails after I sign up

  let(:user) { FactoryGirl.create(:user) }
  before do
    sign_in user
    visit group_path(user.group)
    click_link 'Invite someone to your group'
  end

  scenario 'user enters valid info' do
    fill_in 'Name', with: 'Cool dude'
    fill_in 'Email', with: 'email@email.com'
    before_count = User.count
    click_button 'Send an invitation'
    expect(User.count).to eql(before_count+1)
    expect(current_path).to eql( group_path(user.group) )
  end

  scenario 'user enters invalid info' do
    before_count = User.count
    click_button 'Send an invitation'
    expect(User.count).to eql(before_count)
    expect(page).to have_content("can't be blank")
  end

end
