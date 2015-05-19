FactoryGirl.define do
  factory :user do
    email 'john.doe@example.com'
    password 'Abcd1234'
    confirmed_at Time.now
    
    factory :user_with_username do
      username 'john.doe'
    end
  end
end