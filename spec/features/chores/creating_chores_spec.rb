require 'spec_helper'

describe "creating chores" do

  let(:group) { FactoryGirl.create(:group) }
  let(:user) { FactoryGirl.create(:user, group: group) }

  before do
    sign_in user
    visit chores_path
  end

  context "with invalid info" do
      it "does not create a chore" do
        expect { click_button 'Create Chore' }.not_to change { group.chores.count }
      end
    end

    context "with valid info" do
      before do
        fill_in 'chore_title', with: 'Test title'
        fill_in 'chore_description', with: 'Test description'
        select(user.name, :from => 'chore_user_id')
      end

      it "creates a chore" do
        expect { click_button 'Create Chore' }.to change { Chore.count }.by(1)
      end
    end

end
