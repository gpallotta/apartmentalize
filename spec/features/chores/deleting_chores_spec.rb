require 'spec_helper'

describe "deleting chores" do

  let(:group) { FactoryGirl.create(:group) }
  let(:user) { FactoryGirl.create(:user, group: group) }
  let!(:ch1) { FactoryGirl.create(:chore,
                                  group: group,
                                  user: user)}

  before do
    sign_in user
    visit chores_path
    click_link 'Edit'
  end

  it "deletes the chore" do
    expect{ click_link 'Delete' }.to change{ Chore.count }.by(-1)
  end

end
