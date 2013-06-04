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
      let!(:today) { Time.now }
      it "returns a formatted string of the day the claim was paid" do
        expect(helper.paid_status_for_show_page(cl)).to eql( today.strftime("%B %d, %Y") )
      end
    end
  end


end
