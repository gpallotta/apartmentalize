require 'spec_helper'

describe Seeders::Users do

  let(:seeder) { Seeders::Users }

  it "creates users and a group" do
    group_count = Group.count
    user_count = User.count
    seeder.seed
    expect(Group.count).not_to eql(group_count)
    expect(User.count).not_to eql(user_count)
  end

  it 'can be run multiple times without duplication' do
    seeder.seed
    user_count = User.count
    group_count = Group.count
    seeder.seed
    expect(User.count).to eq(user_count)
    expect(Group.count).to eq(group_count)
  end

end
