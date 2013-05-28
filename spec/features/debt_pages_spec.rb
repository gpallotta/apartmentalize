require 'spec_helper'

describe "debt pages" do

  let(:group) { FactoryGirl.create(:group) }
  let(:user) { FactoryGirl.create(:user, group: group) }

  before do
    sign_in user
    visit debts_path
  end

  subject { page }

  describe "creating debts" do
    context "with invalid info" do
    end

    context "with valid info" do

    end
  end

  describe "viewing debts" do
    it "displays all unpaid debts related to you by default" do
    end
  end


end
