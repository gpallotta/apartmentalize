###############

# As a user
# I want to receive a welcome email when I sign up
# so I know my signup was successful

# AC:
# I receive an email after I sign up for the site
# The email is sent to the address I provide

###############

require 'spec_helper'

describe "user receiving a welcome email" do

  include EmailSpec::Helpers
  include EmailSpec::Matchers

  it "emails the user after they sign up" do
    visit new_group_path
    click_button 'Create New Group'
    fill_in 'Name', with: 'Greg'
    fill_in 'Email', with: 'dude@dude.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_button 'Sign up'
    expect(last_email).to deliver_to('dude@dude.com')
    expect(last_email).to have_subject('Welcome to Apartmentalize')
  end

end
