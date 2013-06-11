require "spec_helper"

describe UserMailer do
  describe "signup_welcome" do
    let!(:user) { FactoryGirl.create(:user, email: 'gregpallotta@gmail.com')}
    let(:mail) { UserMailer.signup_welcome(user) }

    it "renders the headers" do
      mail.subject.should eq("Welcome to Apartment")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      # mail.body.encoded.should match("Hi")
      pending
    end
  end

end
