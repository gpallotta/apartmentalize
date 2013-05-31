require 'spec_helper'

describe "manager pages" do

  let(:group) { FactoryGirl.create(:group) }
  let(:user) { FactoryGirl.create(:user, group: group) }
  let!(:m) { FactoryGirl.create(:manager, group: group) }

  before do
    sign_in user
    visit group_path(group)
    click_link 'Edit'
  end

  describe "deleting a manager" do
    it "deletes the manager" do
      click_link 'Delete'
      expect(page).not_to have_content(m.name)
    end
  end

end
