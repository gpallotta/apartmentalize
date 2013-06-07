###############

# As a user
# I do not want to be able to modify claims I owe to others as paid
# so my roommates can't scam me
#
# Acceptance Criteria
# I cannot mark debts that I owe as paid
# I can still mark debts that others owe me as paid

###############


describe "modifying claims you did not create" do

  extend ClaimsHarness
  create_factories_and_sign_in

  describe "marking as paid" do

    describe "on the index page" do
      before { visit claims_path }
      it "is not possible" do
        expect(page).not_to have_link('Mark as paid',
                href: mark_as_paid_claim_path(cl2) )
      end
    end

    describe "on the show page" do
      it "is not possible" do
        visit claim_path(cl2)
        expect(page).not_to have_link('Mark as paid',
                href: mark_as_paid_claim_path(cl2))
      end
    end

  end

  describe "editing" do
    before { visit claim_path(cl2) }
    it "is not possible" do
      expect(page).not_to have_link('Edit', href: edit_claim_path(cl2) )
    end
  end

end
