# == Schema Information
#
# Table name: managers
#
#  id           :integer          not null, primary key
#  title        :string(255)      not null
#  name         :string(255)      not null
#  phone_number :string(255)      not null
#  address      :string(255)      not null
#  group_id     :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Manager < ActiveRecord::Base

  belongs_to :group

  validates_presence_of :title
  validates_presence_of :name
  validates_presence_of :phone_number
  validates_presence_of :address
  validates_presence_of :group

  validates_length_of :phone_number, is: 10
  validates_format_of :phone_number, with: /\d{10}/

  attr_accessible :address, :group_id, :name, :phone_number, :title
end
