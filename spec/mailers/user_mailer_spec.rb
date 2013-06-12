require "spec_helper"

describe UserMailer do

  include EmailSpec::Helpers
  include EmailSpec::Matchers
  describe "signup_welcome" do
    let!(:user) { FactoryGirl.create(:user, email: 'to@example.org')}
    let(:mail) { UserMailer.signup_welcome(user) }

    it "delivers to the correct email" do
      expect(mail).to deliver_to('to@example.org')
    end

    it "renders the body and subject" do
      expect(mail).to have_subject('Welcome to Apartment')
      expect(mail).to have_body_text('Thanks for signing up')
    end
  end

end
