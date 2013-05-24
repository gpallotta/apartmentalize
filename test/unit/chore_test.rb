# == Schema Information
#
# Table name: chores
#
#  id          :integer          not null, primary key
#  title       :string(255)      not null
#  description :string(255)
#  group_id    :integer          not null
#  user_id     :integer          not null
#  completed   :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class ChoreTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
