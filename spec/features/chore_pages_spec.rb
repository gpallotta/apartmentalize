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

  subject { page }

  describe "viewing chores" do


    it "displays info about each chore" do
      visit chores_path
      should have_content(ch1.title)
      should have_content(ch1.description)
      should have_content(ch1.user.name)
    end
  end

  describe "creating chores" do

    before { select(user.name, :from => 'chore_user_id') }

    context "with invalid info" do

      it "does not create a chore" do
        expect { click_button 'Create Chore' }.not_to change { group.chores.count }
      end

    end

    context "with valid info" do

      before do
        fill_in 'chore_title', with: 'Test title'
        fill_in 'chore_description', with: 'Test description'
      end

      it "creates a chore" do
        expect { click_button 'Create Chore' }.to change { Chore.count }.by(1)
      end

    end

  end

  describe "editing chores" do

    before do
      visit chores_path
      click_link 'Edit'
    end

    it "takes the user to the edit path" do
      expect(current_path).to eql( edit_chore_path(ch1) )
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

  describe "deleting chores" do

    before do
      visit chores_path
      click_link 'Edit'
    end

    it "deletes the chore" do
      expect{ click_link 'Delete' }.to change{ Chore.count }.by(-1)
    end

  end


end
