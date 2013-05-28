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
      it "to the group info page" do
        should have_link('Group Info', href: group_path(group))
      end
    end

    describe "user information" do
    end

  end

end
