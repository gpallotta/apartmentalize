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
    sequence(:description) { |n| "Description #{n}"}
    group
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

end
