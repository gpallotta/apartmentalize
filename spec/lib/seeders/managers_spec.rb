require 'spec_helper'

describe Seeders::Managers do

  let(:seeder) { Seeders::Managers }
  before(:each) { Seeders::Users.seed }

  it "creates some managers for each group" do
    manager_count = Manager.count
    seeder.seed
    expect(Manager.count).not_to eq(manager_count)
  end

  it 'can be run multiple times without duplication' do
    seeder.seed
    manager_count = Manager.count
    seeder.seed
    expect(Manager.count).to eq(manager_count)
  end

end
