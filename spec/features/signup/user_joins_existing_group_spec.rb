require 'spec_helper'

feature 'joining an existing group', %q{
  As a user
  I want to join an existing group
  so I can link up with my roommates on the site
} do

  # AC:
  # I can enter an existing group identifier
  # I am linked up correctly with the group
  # I am notified if I enter an invalid identifier

  before(:each) { visit new_group_path }

  scenario 'user looks up an existing group' do
    FactoryGirl.create(:group, identifier: 'exists')
    fill_in 'lookup_identifier', with: 'exists'
    click_button 'Lookup'
    expect(page).to have_content('exists')
  end

  scenario 'user looks up a nonexistent group' do
    fill_in 'lookup_identifier', with: 'not here'
    click_button 'Lookup'
    expect(page).to have_content("Join existing group")
    expect(page).to have_content("Group not found")
  end

end
