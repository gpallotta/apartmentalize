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

  describe ".partial_path" do
    it "returns the correct path to the partial for the activity type" do
    end
  end



end
