require 'spec_helper'

describe "editing chores" do

  extend ChoresHarness
  create_factories_and_sign_in

  before do
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
