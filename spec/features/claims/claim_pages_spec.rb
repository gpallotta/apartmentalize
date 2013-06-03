# require 'spec_helper'

# describe "claim pages" do

#   let(:group) { FactoryGirl.create(:group) }
#   let(:user1) { FactoryGirl.create(:user, group: group) }
#   let!(:user2) { FactoryGirl.create(:user, group: group) }
#   let!(:user3) { FactoryGirl.create(:user, group: group) }
#   let!(:cl) { FactoryGirl.create(:claim, user_owed_to: user1, user_who_owes: user2)}

#   before do
#     sign_in user1
#     visit claims_path
#   end

#   subject { page }

#   describe "claims index page" do

#     let!(:cl2) { FactoryGirl.create(:claim, user_owed_to: user2,
#                    user_who_owes: user1, amount: 3)}
#     let!(:cl3) { FactoryGirl.create(:claim, user_owed_to: user1,
#                     user_who_owes: user2, paid: true)}
#     let!(:roommate_cl) { FactoryGirl.create(:claim, user_owed_to: user2,
#                     user_who_owes: user3) }

#     describe "viewing totals" do

#       let(:total) { cl.amount + cl3.amount - cl2.amount }
#       before { visit claims_path }

#       it "displays the effective balance" do
#         expect(page).to have_content(total)
#       end

#       it "displays the total for each user" do
#         expect(page).to have_content("#{user2.name} #{total}")
#       end

#     end
#   end
# end
