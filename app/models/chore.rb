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

class Chore < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  validates_presence_of :title
  validates_presence_of :group
  validates_presence_of :user

  attr_accessible :completed, :description, :group_id, :title, :user_id
end
