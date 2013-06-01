require 'spec_helper'

module ChoresHarness

  def create_factories_and_sign_in
    let(:group) { FactoryGirl.create(:group) }
    let(:user) { FactoryGirl.create(:user, group: group) }
    let!(:ch1) { FactoryGirl.create(:chore, group: group, user: user)}
    before { sign_in user }
  end

end
