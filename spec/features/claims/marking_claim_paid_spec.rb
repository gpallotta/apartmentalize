require 'spec_helper'

describe "marking claims as paid" do

  let(:group) { FactoryGirl.create(:group) }
  let(:user1) { FactoryGirl.create(:user, group: group) }
  let!(:user2) { FactoryGirl.create(:user, group: group) }
  let!(:cl) { FactoryGirl.create(:claim, user_owed_to: user1, user_who_owes: user2)}

  before do
    sign_in user1
    visit claims_path
  end

  it "marks the debt as paid" do
    click_link 'Mark paid'
    expect(cl.reload.paid).to be_true
  end
end
