require 'spec_helper'

describe ClaimLinksPresenter do

  include ActionView::TestCase::Behavior
  let(:group) { FactoryGirl.create(:group) }
  let(:user1) { FactoryGirl.create(:user, group: group )}
  let(:user2) { FactoryGirl.create(:user, group: group )}
  let(:claim) { FactoryGirl.create(:claim, user_owed_to: user1, user_who_owes: user2) }
  let(:presenter) { ClaimLinksPresenter.new(claim, view) }

  describe "instance variables" do
    it "has a claim" do
      expect(presenter.claim).to eql(claim)
    end
  end

  describe "methods" do

    describe ".paid_on" do
      it "returns 'unpaid' if the claim is unpaid" do
        expect(presenter.paid_on).to eql('Unpaid')
      end
      it "returns the time the claim was paid if it is paid" do
        claim.mark_as_paid
        expect(presenter.paid_on).to eql(Time.now.utc.strftime("%B %d, %Y"))
      end
    end

    describe ".mark_as_paid_link_id" do
      it "returns a string with the id of the claim" do
        expect(presenter.mark_as_paid_link_id).to include("#{claim.id}")
      end
    end

    describe ".edit_link" do

      context "when the user viewing the claim is the one owed to" do
        it "returns a dead link if the claim is paid" do
          claim.mark_as_paid
          expect(presenter.edit_link(user1)).to include('Cannot edit paid claims')
        end
        it "returns a link to the edit claim path if the claim is unpaid" do
          expect(presenter.edit_link(user1)).to include("/claims/#{claim.id}/edit")
        end
      end

      context "when the user viewing the claim is one who owes" do
        it "returns text indicating the user cannot edit" do
          expect(presenter.edit_link(user2)).to include('Cannot edit')
        end
      end

    end

    describe ".mark_as_paid_link" do
      context "when the user viewing the claim is the one owed to" do
        it "returns a dead link if the claim is paid" do
          claim.mark_as_paid
          expect(presenter.mark_as_paid_link(user1)).to include('Already paid')
        end
        it "returns a mark as paid link if the claim is unpaid" do
          expect(presenter.mark_as_paid_link(user1)).
              to include("/claims/#{claim.id}/mark_as_paid")
        end
      end
    end

  end

end
