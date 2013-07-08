require 'spec_helper'

feature 'creating a user account', %q{
  As a user
  I want to create an account on the site
  so I can use and store my own information
} do

  # AC:
  # I can create a user account
  # The account is unique to me
  # The account is associated with a particular group

  given(:group) { FactoryGirl.create(:group) }

  before(:each) do
    visit new_group_path
    fill_in 'lookup_identifier', with: group.identifier
    click_button 'Lookup'
  end

  scenario 'user creates account with valid info' do
    fill_in 'user_name', with: 'Valid name'
    fill_in 'user_email', with: 'valid@email.com'
    fill_in 'user_password', with: '12345678'
    fill_in 'user_password_confirmation', with: '12345678'
    expect { click_button 'Sign up' }.to change { User.count }.by(1)
    expect(User.last.group).not_to be(nil)
    expect(User.last.group.identifier).to eql(group.identifier)
  end

  scenario 'user creates account with name already taken' do
    named_user = FactoryGirl.create(:user, group: group, name: 'taken')
    visit new_group_path
    fill_in 'lookup_identifier', with: group.identifier
    click_button 'Lookup'
    fill_in 'user_name', with: named_user.name
    expect { click_button 'Sign up' }.not_to change { User.count }
    expect(page).to have_content('Name has already been taken')
  end

  scenario 'user creates account with required fields missing' do
    expect { click_button 'Sign up' }.not_to change { User.count }
    expect(current_path).to eql(user_registration_path)
    expect(page).to have_content("Name can't be blank")
    expect(page).to have_content("Email can't be blank")
    expect(page).to have_content("Password can't be blank")
  end

end
