FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "person#{n}@example.com" }
    password 'Abcd1234'
    confirmed_at Time.now
    
    factory :user_with_username do
      sequence(:username) { |n| "person#{n}" }
    end
  end
end