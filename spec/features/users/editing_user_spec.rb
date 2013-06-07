##############

# As a user
# I want to be able to edit my information
# so I can update it as necessary

# AC:
# I can edit my information
# The new information is reflected in my account

##############

require 'spec_helper'

describe "editing a user" do
  let!(:user) { FactoryGirl.create(:user) }

  before do
    sign_in user
    visit user_path(user)
    click_link 'Edit'
  end

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
