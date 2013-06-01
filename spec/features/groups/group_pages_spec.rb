require 'spec_helper'

describe "group index page" do

  let(:group) { FactoryGirl.create(:group) }
  let(:user1) { FactoryGirl.create(:user, group: group) }
  let!(:user2) { FactoryGirl.create(:user, group: group) }

  before do
    sign_in user1
    visit group_path(group)
  end

  describe "viewing information" do

    context "group info" do
      it "displays the group identifier" do
        expect(page).to have_content(group.identifier)
      end
      it "displays other members of the group" do
        expect(page).to have_content(user2.name)
        expect(page).to have_content(user2.email)
      end
    end

  end

end
