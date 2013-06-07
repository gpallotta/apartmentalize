###############

# As a user
# I want to delete my account from the site
# so that I can stop using it

# AC:
# I can delete my account
# The account is no longer present on the site

###############

require 'spec_helper'

describe "deleting a user" do
  let!(:user) { FactoryGirl.create(:user) }
  before do
    sign_in user
    visit edit_user_registration_path(user)
  end

  it "deletes the user account" do
    expect{ click_button 'Cancel my account' }.to change {User.count}.by(-1)
    expect(current_path).to eql(welcome_page_path)
    expect(page).to have_button 'Sign in'
  end

end
