require 'spec_helper'

module CommentsHarness

  def create_factories_and_sign_in
    let(:group) { FactoryGirl.create(:group) }
    let(:user1) { FactoryGirl.create(:user, group: group) }
    let!(:user2) { FactoryGirl.create(:user, group: group) }
    let!(:cl) { FactoryGirl.create(:claim, user_owed_to: user1,
                    user_who_owes: user2)}
    let!(:com) { FactoryGirl.create(:comment, claim: cl, user: user1)}
    before { sign_in user1 }
  end

end
