require 'spec_helper'

describe ApplicationHelper do

  let!(:group) { FactoryGirl.create(:group) }
  let!(:user1) { FactoryGirl.create(:user, group: group) }
  let!(:user2) { FactoryGirl.create(:user, group: group) }
  let!(:user3) { FactoryGirl.create(:user, group: group) }

  describe ".other_users" do
    it "returns an array of the other users in the group" do
      expect(helper.other_users(user1)).to eql([user2, user3])
    end
  end


end

