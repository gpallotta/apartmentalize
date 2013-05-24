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

  factory :user_who_owes do
    user
  end

  factory :user_owed_to do
    user
  end

  factory :chore do
    sequence(:title) { |n| "Title #{n}"}
    sequence(:description) { |n| "Description #{n}"}
    group
    user
  end

  factory :debt do
    sequence(:title) { |n| "Debt_title #{n}" }
    amount 25.00
    paid false
    user_owed_to
    user_who_owes

    factory :paid do
      paid true
    end
  end

  factory :comment do
    content "Blarg"
    user
    debt
  end

  factory :manager do
    name 'Name'
    title 'Title'
    phone_number '1234567890'
    address 'street'
    group
  end

end
