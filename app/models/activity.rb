class Activity < ActiveRecord::Base

  belongs_to :owner,
    class_name: 'User',
    foreign_key: 'owner_id',
    inverse_of: :activities_as_owner

  belongs_to :recipient,
    class_name: 'User',
    foreign_key: 'recipient_id',
    inverse_of: :activities_as_recipient

  belongs_to :trackable, polymorphic: true

  validates_presence_of :owner
  validates_presence_of :recipient
  validates_presence_of :trackable

  attr_accessible :action, :trackable_type, :trackable

end
