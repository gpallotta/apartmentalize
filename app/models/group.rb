class Group < ActiveRecord::Base
  after_initialize :create_identifier

  has_many :users, dependent: :destroy
  has_many :chores, dependent: :destroy
  has_many :managers, dependent: :destroy

  validates_presence_of :identifier
  validates_uniqueness_of :identifier

  attr_accessible :identifier

  private

  def create_identifier
    if self.identifier == '' or self.identifier == nil
      self.identifier = "#{Faker::Internet.domain_word}-#{Faker::Internet.domain_word}"
    end
  end

end
