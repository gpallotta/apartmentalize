require 'spec_helper'

describe ClaimsHelper do

  let!(:group) { FactoryGirl.create(:group) }
  let!(:user1) { FactoryGirl.create(:user, group: group) }
  let!(:user2) { FactoryGirl.create(:user, group: group) }
  let!(:cl) { FactoryGirl.create(:claim, user_owed_to: user1, user_who_owes: user2)}


  describe ".paid_status_for_show_page" do
    context "when the claim is unpaid" do
      it "returns the string 'unpaid'" do
        expect(helper.paid_status_for_show_page(cl)).to eql('Unpaid')
      end
    end

    context "when the claim is paid" do
      before { cl.mark_as_paid }
      let!(:today) do
        Time.now.utc
      end
      it "returns a formatted string of the day the claim was paid" do
        expect(helper.paid_status_for_show_page(cl)).to eql( Time.now.utc.strftime("%B %d, %Y") )
      end
    end
  end

  describe ".mark_as_paid_link_id" do
    it "returns a link containing the id of the specified claim" do
      expect(helper.mark_as_paid_link_id(cl)).to eql("#{cl.id}-mark-paid-link")
    end
  end

  describe ".user_checkbox_checked" do

    let!(:params) do
      params = {}
      params[:z] = {}
      params[:z][:user_name] = [user1.name]
      params
    end
    let!(:search) { ClaimSearch.new(user1, user1.claims, params) }

    it "returns true if checked_users includes the passed in user" do
      expect( helper.user_checkbox_checked?(user1.name, search) ).to be_true
    end
    it "returns false if checked_users does not include the passed in user" do
      expect( helper.user_checkbox_checked?(user2.name, search) ).to be_false
    end
  end

  describe "mark_as_paid_link" do
    let!(:unpaid_cl) { FactoryGirl.create(:claim) }
    let!(:paid_cl) { FactoryGirl.create(:claim, paid: true) }
    it "returns a link with text 'already paid' if the claim is paid" do
      expect(helper.mark_as_paid_link(paid_cl)).to include('Already paid')
    end
    it "returns a link with text 'mark as paid' if the claim is unpaid" do
      link = "/claims/#{unpaid_cl.id}/mark_as_paid"
      expect(helper.mark_as_paid_link(unpaid_cl)).to include(link)
    end
  end


end
