###############

# As a user
# I want to delete chores
# so that I can remove ones we no longer need

# AC:
# I can delete chores
# The chores no longer are displayed
# The chore is removed from the app

###############

require 'spec_helper'

describe "deleting chores" do

  extend ChoresHarness
  create_factories_and_sign_in

  before do
    visit chores_path
    click_link 'Edit'
  end

  it "deletes the chore" do
    expect{ click_link 'Delete' }.to change{ Chore.count }.by(-1)
    expect(page).not_to have_content(ch1)
  end

end
