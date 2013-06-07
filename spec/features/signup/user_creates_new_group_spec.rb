require 'spec_helper'

describe "signing up with joining an existing group" do

  describe "creating the group" do
    before { visit new_group_path }

    describe "with invalid info" do
      context "when the identifier has been taken" do
        let!(:group) { FactoryGirl.create(:group) }
        before do
          fill_in 'group_identifier', with: group.identifier
          click_button 'Create New Group'
        end

        it "does not create the group" do
          expect(page).to have_content('has already been taken')
          expect(current_path).to eql(groups_path)
        end
      end
    end

    describe "with valid info" do
      context "entering an identifier to use" do
        it "creates a group with the provided identifier" do
          fill_in 'group_identifier', with: 'my_identifier'
          expect { click_button 'Create New Group' }.to change { Group.count }.by(1)
          expect(Group.last.identifier).to eql('my_identifier')
        end
      end

      context "leaving the identifier blank and using default" do
        it "creates a group with a default identifier" do
          expect { click_button 'Create New Group' }.to change { Group.count }.by(1)
          expect(Group.last.identifier).not_to be_blank
        end
      end
    end

  end

end
