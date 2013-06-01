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
  end
  it "redirects to the claims index page" do
    expect(current_path).to eql(claims_path)
  end
  it "no longer displays info about the claim" do
    expect(page).not_to have_content(cl.title)
  end

end
