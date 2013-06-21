require 'spec_helper'

describe ClaimsHelper do

  let!(:group) { FactoryGirl.create(:group) }
  let!(:user1) { FactoryGirl.create(:user, group: group) }
  let!(:user2) { FactoryGirl.create(:user, group: group) }
  let!(:cl) { FactoryGirl.create(:claim, user_owed_to: user1, user_who_owes: user2)}

  describe ".user_checkbox_checked" do

    let!(:params) do
      params = {}
      params[:z] = {}
      params[:z][:user_name] = [user1.name]
      params
    end
    let!(:search) { ClaimSearch.new(user1, user1.claims, params) }

    it "returns true if checked_users includes the passed in user" do
      expect( helper.user_checkbox_checked?(user1.name, search) ).to be_true
    end
    it "returns false if checked_users does not include the passed in user" do
      expect( helper.user_checkbox_checked?(user2.name, search) ).to be_false
    end
  end

  describe ".paid_status" do
    it "returns 'unpaid' if the claim is unpaid'" do
      expect(helper.paid_status(cl)).to eql('Unpaid')
    end
    it "returns 'paid' if the claim is paid" do
      cl.update_attributes(paid: true)
      expect(helper.paid_status(cl)).to eql('Paid')
    end
  end


end
