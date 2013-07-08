require 'spec_helper'

feature 'creating a new group', %q{
  As a user
  I want to be able to create a new group
  so I can create a link for my roommates and I
} do

  # AC:
  # I can create a new group
  # I can enter an identifier to uniquely identiy the group
  # I can use a provided default identifier
  # The new group is associated with my account

  before(:each) { visit new_group_path }

  scenario 'user creates a new group by providing a valid name at signup' do
    fill_in 'group_identifier', with: 'my_identifier'
    expect { click_button 'Create New Group' }.to change { Group.count }.by(1)
    expect(Group.last.identifier).to eql('my_identifier')
  end

  scenario 'user creates new group with identifier already in use' do
    group = FactoryGirl.create(:group)
    fill_in 'group_identifier', with: group.identifier
    click_button 'Create New Group'
    expect(page).to have_content('has already been taken')
    expect(current_path).to eql(groups_path)
  end

  scenario 'user creates a new group by leaving blank and using default' do
    expect { click_button 'Create New Group' }.to change { Group.count }.by(1)
    expect(Group.last.identifier).not_to be_blank
  end

end
