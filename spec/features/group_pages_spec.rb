require 'spec_helper'

describe "group pages" do

  let(:group) { FactoryGirl.create(:group) }
  let(:user1) { FactoryGirl.create(:user, group: group) }
  let!(:user2) { FactoryGirl.create(:user, group: group) }

  before do
    sign_in user1
    visit group_path(group)
  end
  subject { page }

  describe "viewing information" do

    context "group info" do
      it "displays the group identifier" do
        should have_content(group.identifier)
      end
      it "displays other members of the group" do
        should have_content(user2.name)
        should have_content(user2.email)
      end
    end

    context "manager info" do

      let!(:manager) { FactoryGirl.create(:manager, group: group) }
      before { visit current_path }

      it "displays info about each manager" do
        should have_content(manager.name)
        should have_content(manager.title)
        should have_content(manager.email)
        should have_content(manager.address)
        should have_content(manager.phone_number)
      end

      it "has a link to create a new manager" do
        should have_link("Add An Important Person", href: new_manager_path)
      end

      it "has a link to edit a manager" do
        should have_link("Edit", href: edit_manager_path(manager) )
      end
    end

  end

end
