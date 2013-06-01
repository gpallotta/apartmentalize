require 'spec_helper'

module ManagersHarness

  def create_factories_and_sign_in
    let(:group) { FactoryGirl.create(:group) }
    let(:user) { FactoryGirl.create(:user, group: group) }
    let!(:manager) { FactoryGirl.create(:manager, group: group) }
    before { sign_in user }
  end

end
