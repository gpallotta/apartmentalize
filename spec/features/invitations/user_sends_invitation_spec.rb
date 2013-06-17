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
    visit new_user_invitation_path
  end

  scenario 'user enters valid info'

  scenario 'user enters invalid info' do
    before_count = User.count
    click_button 'Send an invitation'
    expect(User.count).to eql(before_count)
    expect(page).to have_content("can't be blank")
  end

end
