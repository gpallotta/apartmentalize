require 'spec_helper'

describe "deleting chores" do

  extend ChoresHarness
  create_factories_and_sign_in

  before do
    visit chores_path
    click_link 'Edit'
  end

  it "deletes the chore" do
    expect{ click_link 'Delete' }.to change{ Chore.count }.by(-1)
  end

end
