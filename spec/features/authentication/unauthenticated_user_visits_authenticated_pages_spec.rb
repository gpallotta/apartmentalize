######################

# As a user
# I want to be redirected to the sign in page when I visit pages which require me to be authenticated
# so that I don't see things I'm not supposed to or cause errors
#
# Acceptance Criteria
# I cannot visit the claim, home, comment, or user/group info pages if I am not authenticated
# I am redirected back to the welcome page

######################

require 'spec_helper'

describe "an unauthenticated user visiting pages which need authentication" do

  describe "claim pages" do
    context "claims_path" do
      it "redirects back to the sign in page" do
        visit claims_path
        expect(current_path).to eql(new_user_session_path)
      end
    end
  end

  describe "group pages" do
    context "group_path(group)" do
      let!(:group) { FactoryGirl.create(:group) }
      it "redirects back to the sign in page" do
        visit group_path(group)
        expect(current_path).to eql(new_user_session_path)
      end
    end
  end

  describe "user pages" do
    let!(:user) { FactoryGirl.create(:user) }
    context "user_path" do
      it "redirects back to the sign in page" do
        visit user_path(user)
        expect(current_path).to eql(new_user_session_path)
      end
    end

    context "edit_user_path" do
      before { visit edit_user_registration_path(user) }
      it "displays a message telling the user they need to log in" do
        visit edit_user_registration_path(user)
        expect(page).to have_content('You need to sign in or sign up')
      end
      it "display content from the edit page" do
        expect(page).not_to have_content('Edit User')
      end
    end
  end

  describe "chore pages" do
    let!(:chore) { FactoryGirl.create(:chore)}
    context "chores_path" do
      it "redirects back to the sign in page" do
        visit chores_path
        expect(current_path).to eql(new_user_session_path)
      end
    end
    context "edit_chore_path" do
      it "redirects back to the sign in page" do
        visit edit_chore_path(chore)
        expect(current_path).to eql(new_user_session_path)
      end
    end
  end

end
