require 'spec_helper'

describe ActivityPresenter do

  include ActionView::TestCase::Behavior

  let!(:activity) { Activity.new()}

  describe "instance variables" do
    let!(:presenter) { ActivityPresenter.new(activity, view) }
    it "has an activity" do
      presenter = ActivityPresenter.new(activity, view)
      expect(presenter.activity).to be_an(Activity)
    end
  end

  describe "methods" do

    let!(:group) { FactoryGirl.create(:group)}
    let!(:user1) { FactoryGirl.create(:user) }
    let!(:user2) { FactoryGirl.create(:user) }
    let!(:claim) { FactoryGirl.create(:claim, user_owed_to: user1,
            user_who_owes: user2) }

    let!(:activity) do
      a = Activity.new(trackable: claim, action: 'create')
      a.trackable_type = 'Claim'
      a.owner = user1
      a.recipient = user2
      a.save
      a
    end

    let!(:presenter) { ActivityPresenter.new(activity, view) }

    describe ".partial_path" do
      it "returns the correct path to the partial for the activity type" do
        expect(presenter.partial_path).to eql('activities/claim/create')
      end
    end

    describe ".render_partial" do
      it "returns the correct html for the page" do
        expect(presenter.render_partial).to include('created a new claim for')
      end
    end

    describe ".deleted_message" do
      it "returns a message indicating the item was deleted" do
        expect(presenter.deleted_message).to eql("#{user1.name} deleted this claim")
      end
    end

  end

end
