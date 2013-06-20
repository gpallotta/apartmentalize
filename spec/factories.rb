FactoryGirl.define do

  factory :group do
    sequence(:identifier) { |n| "identifier_#{n}" }
  end

  factory :user do
    sequence(:name) { |n| "person#{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    password "password"
    password_confirmation "password"
    receives_weekly_email false
    group
  end

  factory :chore do
    sequence(:title) { |n| "title #{n}"}
    sequence(:description) { |n| "Description #{n}"}
    group
    user
  end

  factory :claim do
    sequence(:title) { |n| "claim_title #{n}" }
    amount 25.00
    paid false
    association :user_owed_to, factory: :user
    association :user_who_owes, factory: :user

    factory :paid do
      paid true
    end
  end

  factory :comment do
    sequence(:content) { |n| "blarg#{n}"}
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

  factory :donation do
    email 'greg@greg.com'
    name 'Greg'
    amount 1
    stripe_card_token "tok_23I4fpEaOUCAZf"
  end

  factory :card do
    number 4242424242424242
    cvc 123
    expMonth 12
    expYear 2028
  end

end
