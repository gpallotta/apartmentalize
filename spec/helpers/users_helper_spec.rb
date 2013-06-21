require 'spec_helper'

describe UsersHelper do

  let(:user) { FactoryGirl.create(:user) }

  describe ".receive_weekly_email" do
    it "indicates if user is receiving weekly email" do
      user.receives_weekly_email = true
      expect(helper.receive_weekly_email(user))
          .to eql('You are receiving weekly email summaries')
    end
    it "indicates if the user is not receiving weekly email" do
      expect(helper.receive_weekly_email(user))
          .to eql("You are not receiving weekly email summaries")
    end
  end

end
