require 'spec_helper'

describe SummaryDispatcher::DailySummary do

  include EmailSpec::Helpers
  include EmailSpec::Matchers

  let!(:subscribed_user) { FactoryGirl.create(:user, receives_daily_email: true)}
  let!(:unsubscribed_user) { FactoryGirl.create(:user)}


  describe ".send_daily_summary" do
    it "sends daily summary to subscribed users" do
      sent_to_subscribed, sent_to_unsubscribed = false, false
      SummaryDispatcher::DailySummary.send_daily_summary
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
