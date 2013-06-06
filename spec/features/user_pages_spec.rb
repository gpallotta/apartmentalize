require 'spec_helper'

describe "user pages" do

  let(:group) { FactoryGirl.create(:group) }
  let(:user) { FactoryGirl.create(:user, group: group) }

  before do
    sign_in user
    visit user_path(user)
  end
  subject { page }

  describe "profile page" do

    context "links" do
      it "links to the user info page" do
        should have_link('User Info', href: user_path(user))
      end
      it "links to the group info page" do
        should have_link('Group Info', href: group_path(group))
      end
      it "links to the user edit page" do
        should have_link('Edit', href: edit_user_registration_path(user))
      end
    end

    describe "user information" do
      it "shows the user's info" do
        expect(page).to have_content(user.name)
        expect(page).to have_content(user.email)
        expect(page).to have_content(user.group.identifier)
      end
    end

  end

  describe "editing a user" do
    before { click_link 'Edit' }

    context "with invalid info" do
      before do
        fill_in 'Email', with: ''
      end
      it "does not save the changes" do
        before_email = user.email
        click_button 'Update'
        expect(user.reload.email).to eql(before_email)
      end
      it "renders errors" do
        click_button 'Update'
        expect(page).to have_content("Current password can't be blank")
      end
    end

    context "with valid info" do
      before do
        fill_in 'Email', with: 'new@new_email.com'
        fill_in 'user_current_password', with: user.password
        click_button 'Update'
      end
      it "saves the changes" do
        expect(user.reload.email).to eql('new@new_email.com')
      end
      it "displays the new email" do
        expect(page).to have_content('new@new_email.com')
      end
      it "redirects to the user info page" do
        expect(current_path).to eql(user_path(user))
      end
    end
  end

  describe "deleting a user" do
    before { click_link 'Edit' }
    it "deletes the user account" do
      expect{ click_button 'Cancel my account' }.to change {User.count}.by(-1)
    end
    it "returns the user to the front page" do
      click_button 'Cancel my account'
      expect(current_path).to eql(welcome_page_path)
      should have_button 'Sign in'
    end
  end

end
