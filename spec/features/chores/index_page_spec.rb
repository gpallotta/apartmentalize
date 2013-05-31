require 'spec_helper'

describe "chore pages" do

  let(:group) { FactoryGirl.create(:group) }
  let(:user) { FactoryGirl.create(:user, group: group) }
  let!(:ch1) { FactoryGirl.create(:chore,
                                  group: group,
                                  user: user)}

  before do
    sign_in user
    visit chores_path
  end

  describe "viewing chores" do

    it "displays info about each chore" do
      expect(page).to have_content(ch1.title)
      expect(page).to have_content(ch1.description)
      expect(page).to have_content(ch1.user.name)
    end
  end

end
