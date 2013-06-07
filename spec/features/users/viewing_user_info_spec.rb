###############

# As a user
# I want to view my information on the site
# so I can see if it is up to date

# AC:
# I can view my information when I am logged in

###############


require 'spec_helper'

describe "viewing user information" do
  let!(:user) { FactoryGirl.create(:user) }
  before do
    sign_in user
    visit user_path(user)
  end

  it "shows the user's info" do
    expect(page).to have_content(user.name)
    expect(page).to have_content(user.email)
    expect(page).to have_content(user.group.identifier)
  end

  it "links to the user edit page" do
    expect(page).to have_link('Edit', href: edit_user_registration_path(user))
  end

  it "links to the group info page" do
    expect(page).to have_link('Group Info', href: group_path(user.group) )
  end

end
