###############

# As a user
# I want to be redirected when I visit an unrelated claim
# so others can't see things not related to them

# AC:
# I am redirected when I try to visit the page of an unrelated claim
# I do not see any info about the claim I tried to visit

###############


require 'spec_helper'

describe "user visiting claim page of unrelated claim" do

  extend ClaimsHarness
  create_factories_and_sign_in
  let!(:cl3) { FactoryGirl.create(:claim, user_owed_to: user3,
                user_who_owes: user2) }

  it "redirects back to the claims path" do
    visit claim_path(cl3)
    expect(current_path).to eql(claims_path)
    expect(page).not_to have_content(cl3.title)
  end

end
