require 'spec_helper'

describe SummaryDispatcher::WeeklySummary do

  include EmailSpec::Helpers
  include EmailSpec::Matchers

  let!(:subscribed_user) { FactoryGirl.create(:user, receives_weekly_email: true)}
  let!(:unsubscribed_user) { FactoryGirl.create(:user)}

  describe ".send_weekly_summary" do
    it "sends weekly summary to subscribed users" do
      sent_to_subscribed, sent_to_unsubscribed = false, false
      SummaryDispatcher::WeeklySummary.send_weekly_summary
      ActionMailer::Base.deliveries.each do |mail|
        to = mail.to.to_s.slice(2..-3)
        sent_to_subscribed = true if to == subscribed_user.email
        sent_to_unsubscribed = true if to == unsubscribed_user.email
      end
      expect(sent_to_subscribed).to be_true
      expect(sent_to_unsubscribed).to be_false
    end
  end

end

