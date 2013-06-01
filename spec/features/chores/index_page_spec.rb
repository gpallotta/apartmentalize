require 'spec_helper'

describe "chore pages" do

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
