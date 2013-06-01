require 'spec_helper'

describe "marking claims as paid" do

  extend ClaimsHarness
  create_factories_and_sign_in

  before do
    visit claims_path
    click_link 'Mark paid'
  end

  it "marks the debt as paid" do
    expect(cl.reload.paid).to be_true
  end
  it "redirects back to the claims page" do
    expect(current_path).to eql(claims_path)
  end
end
