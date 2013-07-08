require 'spec_helper'

describe Seeders::Chores do

  let(:seeder) { Seeders::Chores }
  before(:each) { Seeders::Users.seed }

  it "creates a chore for each seeded user" do
    chore_count = Chore.count
    seeder.seed
    expect(Chore.count).not_to eq(chore_count)
  end

  it 'can be run multiple times without duplication' do
    seeder.seed
    chore_count = Chore.count
    seeder.seed
    expect(Chore.count).to eq(chore_count)
  end

end
