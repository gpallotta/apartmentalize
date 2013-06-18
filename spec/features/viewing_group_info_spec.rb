require 'spec_helper'

feature 'user seeing group info', %q{
  As a user
  I want to see a list of others in the group
  so I know who is using the site with me
} do

  # AC:
  # I can see a list of users in my group
  # I can see their contact information

  let(:group) { FactoryGirl.create(:group) }
  let(:user1) { FactoryGirl.create(:user, group: group) }
  let!(:user2) { FactoryGirl.create(:user, group: group) }

  scenario 'user visits group show page' do
    sign_in user1
    visit group_path(group)
    expect(page).to have_content(group.identifier)
    expect(page).to have_content(user2.name)
    expect(page).to have_content(user2.email)
  end

end
