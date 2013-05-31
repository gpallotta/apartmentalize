require 'spec_helper'

describe "editing a manager" do

  let(:group) { FactoryGirl.create(:group) }
  let(:user) { FactoryGirl.create(:user, group: group) }
  let!(:m) { FactoryGirl.create(:manager, group: group) }

  before do
    sign_in user
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

end
