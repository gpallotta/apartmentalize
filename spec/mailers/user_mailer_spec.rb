require "spec_helper"

describe UserMailer do

  include EmailSpec::Helpers
  include EmailSpec::Matchers
  let!(:user) { FactoryGirl.create(:user, email: 'to@example.org')}
  describe "signup_welcome" do
    let(:mail) { UserMailer.signup_welcome(user.id) }

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
    let!(:user3) { FactoryGirl.create(:user, group: user.group)}
    let!(:cl1) { FactoryGirl.create(:claim, user_owed_to: user,
                    user_who_owes: user2)}
    let!(:cl2) { FactoryGirl.create(:claim, user_owed_to: user2,
                    user_who_owes: user, amount: 4.79)}
    let!(:cl3) { FactoryGirl.create(:claim, user_owed_to: user,
                    user_who_owes: user3, amount: 8.32)}
    let!(:ch1) { FactoryGirl.create(:chore, user: user)}
    let!(:ch2) { FactoryGirl.create(:chore, user: user2)}
    let!(:mail) { UserMailer.weekly_summary(user.id) }

    it "delivers to the correct email" do
      expect(mail).to deliver_to('to@example.org')
    end

    it "sends wth the correct subject" do
      expect(mail).to have_subject('Apartment - Weekly Summary')
      expect(mail).to have_body_text('Weekly Summary')
    end

    it "has any chores assigned to the user for the week" do
      expect(mail).to have_body_text(ch1.title)
      expect(mail).not_to have_body_text(ch2.title)
    end

    it "has the total balance between you and all users" do
      expect(mail).to have_body_text("#{cl1.amount - cl2.amount + cl3.amount}")
    end

    it "has the balance between you and each individual user" do
      expect(mail).to have_body_text("#{cl1.amount - cl2.amount}")
      expect(mail).to have_body_text("#{cl3.amount}")
    end

    it "has a link to the claims page" do
      expect(mail).to have_body_text("/claims")
    end

    it "has a link to the chores page" do
      expect(mail).to have_body_text("/chores")
    end

    it "has a link to the home page" do
      expect(mail).to have_body_text("Visit the site")
    end

  end

  describe "daily_summary" do
    let(:user2) { FactoryGirl.create(:user, group: user.group)}
    let!(:cl1) { FactoryGirl.create(:claim, user_who_owes: user,
                  user_owed_to: user2 )}
    let!(:cl2) { FactoryGirl.create(:claim, user_who_owes: user,
                  user_owed_to: user2, created_at: Date.yesterday)}
    let!(:cl3) { FactoryGirl.create(:claim, user_who_owes: user2,
                  user_owed_to: user)}

    let!(:mail) { UserMailer.daily_summary(user) }

    it "delivers to the correct email" do
      expect(mail).to deliver_to('to@example.org')
    end

    it "renders the body and subject" do
      expect(mail).to have_subject('Apartment - Daily Summary')
      expect(mail).to have_body_text('Daily Summary')
    end

    it "displays claims you owe that were created today" do
      expect(mail).to have_body_text("#{cl1.title}")
      expect(mail).not_to have_body_text("#{cl2.title}")
    end

    it "does not display claims you created today" do
      expect(mail).not_to have_body_text("#{cl3.title}")
    end
  end

end
