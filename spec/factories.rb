FactoryGirl.define do

  factory :group do
    sequence(:identifier) { |n| "identifier_#{n}" }
  end

  factory :user do
    sequence(:name) { |n| "Person#{n}" }
    sequence(:email) { |n| "Person_#{n}@example.com" }
    password "password"
    password_confirmation "password"
    group
  end

  factory :chore do
    sequence(:title) { |n| "Title #{n}"}
    sequence(:description) { |n| "Description #{n}"}
    group
    user
  end

  factory :claim do
    sequence(:title) { |n| "Claim_title #{n}" }
    amount 25.00
    paid false
    association :user_owed_to, factory: :user
    association :user_who_owes, factory: :user

    factory :paid do
      paid true
    end
  end

  factory :comment do
    sequence(:content) { |n| "Blarg#{n}"}
    user
    claim
  end

  factory :manager do
    name 'Greg'
    title 'Landlord'
    email 'landlord@landlord.com'
    phone_number '1234567890'
    address 'street'
    group
  end

end
