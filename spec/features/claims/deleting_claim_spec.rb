###############

# As a user
# I want to be able to delete claims that I created
# so I can remove erroneous entries

# AC:
# I can delete claims I owe
# the claims no longer appear anywhere in the application

###############


require 'spec_helper'

describe "deleting claims" do

  extend ClaimsHarness
  create_factories_and_sign_in

  before do
    visit claim_path(cl)
    click_link 'Edit'
    click_link 'Delete this claim'
  end

  it "deletes the claim" do
    expect(Claim.find_by_id(cl.id)).to be_nil
    expect(current_path).to eql(claims_path)
    expect(page).not_to have_content(cl.title)
  end
end
