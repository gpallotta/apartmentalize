class Manager < ActiveRecord::Base

  belongs_to :group

  validates_presence_of :name
  validates_presence_of :title
  validates_presence_of :group

  validates_length_of :phone_number, is: 10
  validates_format_of :phone_number, with: /\d{10}/

  attr_accessible :address, :group_id, :name, :phone_number, :title, :email
end
