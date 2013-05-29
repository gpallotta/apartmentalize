require 'spec_helper'

describe ClaimBalance do

  let(:group) { FactoryGirl.create(:group)}
  let(:user1) { FactoryGirl.create(:user, group: group) }
  let(:user2) { FactoryGirl.create(:user, group: group) }
  let!(:cl1) { FactoryGirl.create(:claim, user_owed_to: user1,
                user_who_owes: user2) }
  let!(:cl2) { FactoryGirl.create(:claim, user_owed_to: user2,
                user_who_owes: user1, amount: 3)}
  let!(:claim_balance) { c = ClaimBalance.new(user1, [cl1,cl2]) }

  subject { claim_balance }


  describe "methods" do

    describe "user" do
      it "has a user" do
        expect(claim_balance.user).to be_a(User)
      end
    end

    describe "claims" do
      it "has a list of claims" do
        expect(claim_balance.claims.first).to be_a(Claim)
      end
    end

    describe "total" do
      it "returns the effective balance of the claims" do
        expect(claim_balance.total).to eql(cl1.amount - cl2.amount)
      end
    end

    describe "balances" do
      it "is a hash" do
        expect(claim_balance.user_balances).to be_a(Hash)
      end
      it "has a default" do
        expect(claim_balance.user_balances["unused"]).to eql(0)
      end
      it "returns the effective balance for a particular user" do
        expect(claim_balance.user_balances[user2.name]).to eql(cl1.amount - cl2.amount)
      end
    end

  end

end
