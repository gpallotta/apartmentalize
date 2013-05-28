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
    let!(:chore) { FactoryGirl.create(:chore, user: user)}
    it "shows chores currently assigned to you" do
      visit root_path
      should have_content(chore.title)
    end
  end

  describe "debt links" do
    pending
  end

end
