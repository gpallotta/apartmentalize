require 'spec_helper'

describe Seeders::Claims do

  let(:seeder) { Seeders::Claims }
  before(:each) { Seeders::Users.seed }

  it "creates claims for seeded users" do
    claim_count = Claim.count
    user_claim_count = User.first.claims_to_receive.count
    seeder.seed
    expect(Claim.count).not_to eq(claim_count)
    expect(User.first.claims_to_receive.count).not_to eq(user_claim_count)
  end

  it 'can be run multiple times without duplication' do
    seeder.seed
    claim_count = Claim.count
    user_claim_count = User.first.claims_to_receive.count
    seeder.seed
    expect(Claim.count).to eq(claim_count)
    expect(User.first.claims_to_receive.count).to eq(user_claim_count)
  end

end
