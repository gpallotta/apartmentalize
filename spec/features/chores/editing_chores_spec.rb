require 'spec_helper'

describe "editing chores" do

  let(:group) { FactoryGirl.create(:group) }
  let(:user) { FactoryGirl.create(:user, group: group) }
  let!(:ch1) { FactoryGirl.create(:chore,
                                  group: group,
                                  user: user)}

  before do
    sign_in user
    visit chores_path
    click_link 'Edit'
  end

  context "with invalid info" do
    it "does not save the changes" do
      fill_in "chore_title", with: ''
      click_button 'Save changes'
      expect(ch1.reload.title).not_to eql('')
    end
  end

  context 'with valid info' do
    it "saves the changes" do
      fill_in 'chore_title', with: 'Updated title'
      click_button 'Save changes'
      expect(ch1.reload.title).to eql('Updated title')
    end
  end


end
