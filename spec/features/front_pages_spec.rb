require 'spec_helper'

describe "front pages" do

  let(:group) { FactoryGirl.create(:group) }
  let(:user) { FactoryGirl.create(:user, group: group) }

  before { sign_in user }
  subject { page }

  describe "news feed" do
    pending
  end

  describe "current chore" do
    pending
  end

  describe "debt links" do
    pending
  end

end
