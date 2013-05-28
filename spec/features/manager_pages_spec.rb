require 'spec_helper'

describe "manager pages" do

  let(:group) { FactoryGirl.create(:group) }
  let(:user) { FactoryGirl.create(:user, group: group) }

  before do
    sign_in user
    visit group_path(group)
  end

  subject { page }

  describe "creating a new manager" do

    before { click_link 'Add An Important Person' }

    context "with invalid info" do
      it "does not create a manager" do
        expect { click_button 'Create' }.not_to change { Manager.count }
      end
    end

    context "with valid info" do

      before do
        fill_in 'Title', with: 'Awesome Dude'
        fill_in 'manager_name', with: 'Dude'
        fill_in 'Address', with: '123 Blueberry Lane'
        fill_in 'Phone Number', with: '1234567890'
      end

      it "creates a manager" do
        expect { click_button 'Create' }.to change { Manager.count }.by(1)
      end

      it "displays the newly created manager" do
        click_button 'Create'
        should have_content('Awesome Dude')
      end

    end

  end

  describe "editing a manager" do
    let!(:m) { FactoryGirl.create(:manager, group: group) }

    before do
      visit group_path(group)
      click_link 'Edit'
    end

    context "with invalid info" do
      before do
        fill_in 'manager_name', with: ''
        click_button 'Save Changes'
      end

      it "does not save the changes" do
        expect(m.reload.name).not_to eql('')
      end
    end

    context "with valid info" do
      before do
        fill_in 'manager_name', with: 'New Name'
        click_button 'Save Changes'
      end
      it "saves the changes" do
        expect(page).to have_content('New Name')
      end
    end

    describe "deleting a manager" do
      it "deletes the manager" do
        click_link 'Delete'
        expect(page).not_to have_content(m.name)
      end

    end

  end

end
