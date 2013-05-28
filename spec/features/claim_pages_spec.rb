require 'spec_helper'

describe "claim pages" do

  let(:group) { FactoryGirl.create(:group) }
  let(:user) { FactoryGirl.create(:user, group: group) }

  before do
    sign_in user
    visit claims_path
  end

  subject { page }

  describe "creating claims" do
    context "with invalid info" do
    end

    context "with valid info" do

    end
  end

  describe "viewing claims" do
    it "displays all unpaid claims related to you by default" do
    end
  end


end
