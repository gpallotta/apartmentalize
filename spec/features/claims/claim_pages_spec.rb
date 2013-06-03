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



#   end for searching claims

#   #   describe "sorting claims" do

#   #     before { visit claims_path }

#   #     context "by owed_to" do

#   #       before { click_link 'Owed to' }

#   #       it "sorts by descending order" do
#   #         expect(page.body.index(cl2.title)).to be < page.body.index(cl.title)
#   #       end
#   #       it "sorts by acesnding if clicked again" do
#   #         click_link 'Owed to'
#   #         expect(page.body.index(cl2.title)).to be > page.body.index(cl.title)
#   #       end
#   #     end

#   #     context "by owed_by" do
#   #       before { click_link 'Owed by' }

#   #       it "sorts by descending order" do
#   #         expect(page.body.index(cl.title)).to be < page.body.index(cl2.title)
#   #       end
#   #       it "sorts by ascending if clicked again" do
#   #         click_link 'Owed by'
#   #         expect(page.body.index(cl.title)).to be > page.body.index(cl2.title)
#   #       end

#   #     end

#   #     context "by title" do
#   #       before { click_link 'Title' }

#   #       it "sorts by descending order" do
#   #         expect(page.body.index(cl.title)).to be < page.body.index(cl2.title)
#   #       end
#   #       it "sorts by ascending if clicked again" do
#   #         click_link 'Title'
#   #         expect(page.body.index(cl.title)).to be > page.body.index(cl2.title)
#   #       end
#   #     end

#   #     context "by amount" do
#   #       before { click_link 'Amount' }

#   #       it "sorts by descending order" do
#   #         expect(page.body.index(cl2.title)).to be < page.body.index(cl.title)
#   #       end
#   #       it "sorts by ascending if clicked again" do
#   #         click_link 'Amount'
#   #         expect(page.body.index(cl2.title)).to be > page.body.index(cl.title)
#   #       end
#   #     end

#   #     context "by created on" do
#   #       let!(:old_claim) { FactoryGirl.create(:claim, user_owed_to: user1,
#   #                       user_who_owes: user2, created_at: 1.day.ago,
#   #                       title: 'old title') }
#   #       before do
#   #         click_link 'Created on'
#   #       end

#   #       it "sorts by descending order" do
#   #         expect(page.body.index(old_claim.title)).to be < page.body.index(cl.title)
#   #       end
#   #       it "sorts by ascending if clicked again" do
#   #         click_link 'Created on'
#   #         expect(page.body.index(old_claim.title)).to be > page.body.index(cl.title)
#   #       end
#   #     end
#   #   end
#   # end

# end
