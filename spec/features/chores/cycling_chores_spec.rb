require 'spec_helper'

feature 'Chores cycle automatically', %q{
  As a user
  I want to have chores cycle between users automatically
  so we can share responsibility
} do

  given(:group) { FactoryGirl.create(:group) }
  given!(:user1) { FactoryGirl.create(:user, group: group)}
  given!(:user2) { FactoryGirl.create(:user, group: group)}
  given!(:user3) { FactoryGirl.create(:user, group: group)}
  given!(:ch1) { FactoryGirl.create(:chore, user: user1, group: group)}
  given!(:ch2) { FactoryGirl.create(:chore, user: user2, group: group)}
  given!(:ch3) { FactoryGirl.create(:chore, user: user3, group: group)}

  scenario 'chores cycle between users in group' do
    group.cycle_chores
    expect(ch1.reload.user).to eql(user3)
    expect(ch2.reload.user).to eql(user1)
    expect(ch3.reload.user).to eql(user2)
  end

end
