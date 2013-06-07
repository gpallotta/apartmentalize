###############

# As a user
# I want to see information about each chore
# so I know what I need to do

# AC:
# I can see the name and description of chores
# I can see who all chores are assigned to

###############

require 'spec_helper'

describe "viewing chore information" do

  extend ChoresHarness
  create_factories_and_sign_in

  before { visit chores_path }

  describe "viewing chores" do

    it "displays info about each chore" do
      expect(page).to have_content(ch1.title)
      expect(page).to have_content(ch1.description)
      expect(page).to have_content(ch1.user.name)
    end
  end

end
