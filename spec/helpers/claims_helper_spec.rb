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

  describe "mark_paid_link_user_parse" do
    let!(:cl_you_owe) { FactoryGirl.create(:claim, user_who_owes: user1,
              user_owed_to: user2) }

    it "returns 'not' applicable' if you do not owe the claim" do
      expect(helper.mark_paid_link_user_parse(cl_you_owe, user1)).to include('Not applicable')
    end
    it "returns a link if the claim is owed to you" do
      expect(helper.mark_paid_link_user_parse(cl, user1)).to include('Mark as paid')
    end
  end

  describe "link_for_claim" do
    let!(:unpaid_cl) { FactoryGirl.create(:claim) }
    let!(:paid_cl) { FactoryGirl.create(:claim, paid: true) }
    it "returns a link with text 'already paid' if the claim is paid" do
      expect(helper.link_for_claim(paid_cl)).to include('Already paid')
    end
    it "returns a link with text 'mark as paid' if the claim is unpaid" do
      link = "/claims/#{unpaid_cl.id}/mark_as_paid"
      expect(helper.link_for_claim(unpaid_cl)).to include(link)
    end
  end

  describe ".edit_claim_link" do
    let!(:cl2) { FactoryGirl.create(:claim,
                  user_owed_to: user2, user_who_owes: user1) }
    it "returns text 'cannot edit' if the claim is not theirs" do
      expect(helper.edit_claim_link(cl2, user1)).to include('Cannot edit')
    end
    it "returns a link to the edit action if the claim is theirs" do
      expect(helper.edit_claim_link(cl, user1)).to include('Edit')
    end
  end

  describe ".edit_link_for_paid_status" do
    let!(:paid_cl) { FactoryGirl.create(:claim, paid: true) }

    it "returns a link to the edit page if the claim is unpaid" do
      expect(helper.edit_link_for_paid_status(cl)).to include('Edit')
    end

    it "returns text 'cannot edit paid claims' if the claim is paid" do
      expect(helper.edit_link_for_paid_status(paid_cl)).to include('Cannot edit paid claims')
    end
  end

  describe ".paid_status" do
    it "returns 'unpaid' if the claim is unpaid'" do
      expect(helper.paid_status(cl)).to eql('Unpaid')
    end
    it "returns 'paid' if the claim is paid" do
      cl.update_attributes(paid: true)
      expect(helper.paid_status(cl)).to eql('Paid')
    end
  end


end
