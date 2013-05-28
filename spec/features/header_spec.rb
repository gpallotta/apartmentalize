require 'spec_helper'

describe "header" do

  let(:group) { FactoryGirl.create(:group) }
  let(:user) { FactoryGirl.create(:user, group: group) }

  before { sign_in user }
  subject { page }

  describe "links" do

    context "sign out" do
      it "shows a sign out link" do
        should have_link('Sign out', href: destroy_user_session_path)
      end
    end

  end

end
