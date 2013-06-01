require 'spec_helper'

module ClaimsHarness

  def create_factories_and_sign_in
    let!(:group) { FactoryGirl.create(:group) }
    let!(:user1) { FactoryGirl.create(:user, group: group) }
    let!(:user2) { FactoryGirl.create(:user, group: group) }
    let!(:user3) { FactoryGirl.create(:user, group: group) }
    let!(:cl) { FactoryGirl.create(:claim, user_owed_to: user1, user_who_owes: user2)}
    before { sign_in user1 }
  end

end
