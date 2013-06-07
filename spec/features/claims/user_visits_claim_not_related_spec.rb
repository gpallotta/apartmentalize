require 'spec_helper'

describe "user visiting claim page of unrelated claim" do

  extend ClaimsHarness
  create_factories_and_sign_in
  let!(:cl3) { FactoryGirl.create(:claim, user_owed_to: user3,
                user_who_owes: user2) }

  it "redirects back to the claims path" do
    visit claim_path(cl3)
    expect(current_path).to eql(claims_path)
  end

end
