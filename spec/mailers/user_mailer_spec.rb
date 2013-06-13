require "spec_helper"

describe UserMailer do

  include EmailSpec::Helpers
  include EmailSpec::Matchers
  let!(:user) { FactoryGirl.create(:user, email: 'to@example.org')}
  describe "signup_welcome" do
    let(:mail) { UserMailer.signup_welcome(user) }

    it "delivers to the correct email" do
      expect(mail).to deliver_to('to@example.org')
    end

    it "renders the body and subject" do
      expect(mail).to have_subject('Welcome to Apartment')
      expect(mail).to have_body_text('Thanks for signing up')
    end
  end

  describe "weekly_summary" do
    let!(:user2) { FactoryGirl.create(:user, group: user.group)}
    let!(:cl1) { FactoryGirl.create(:claim, user_owed_to: user,
                    user_who_owes: user2)}
    let!(:cl2) { FactoryGirl.create(:claim, user_owed_to: user2,
                    user_who_owes: user, amount: 4.79)}
    let(:mail) { UserMailer.weekly_summary(user) }

    it "delivers to the correct email" do
      expect(mail).to deliver_to('to@example.org')
    end

    it "renders the body and subject" do
      expect(mail).to have_subject('Apartment - Weekly Summary')
      expect(mail).to have_body_text('Weekly Summary')
      expect(mail).to have_body_text("#{cl1.amount - cl2.amount}")
    end
  end

end
