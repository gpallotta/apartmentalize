require 'spec_helper'

feature 'user edits chore', %q{
  As a user
  I want to edit chores
  so I can amend erroneous information
} do

  # AC:
  # I can edit the description and user of a chore
  # I am notified when a chore is changed by a different user

  extend ChoresHarness
  create_factories_and_sign_in

  before(:each) do
    visit chores_path
    click_link 'Edit'
  end

  scenario 'user edits chore with valid info' do
    fill_in "chore_title", with: ''
    click_button 'Save changes'
    expect(ch1.reload.title).not_to eql('')
  end

  scenario 'user edits chore with invalid info' do
    fill_in 'chore_title', with: 'Updated title'
    click_button 'Save changes'
    expect(ch1.reload.title).to eql('Updated title')
  end

end
