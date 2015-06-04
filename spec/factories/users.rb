FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| 'person' + n.to_s + '@example.com' }
    password 'Abcd1234'
    confirmed_at Time.zone.now

    factory :user_with_username do
      sequence(:username) { |n| 'person' + n.to_s }
    end

    factory :premium_user do
      role 'premium'
    end

    factory :admin_user do
      role 'admin'
    end
  end
end
