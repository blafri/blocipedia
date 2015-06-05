FactoryGirl.define do
  factory :wiki do
    user
    sequence(:title) { |n| "Wiki Title nuber #{n}" }
    body "Wiki body"
    
    factory :wiki_user_has_username do
      association :user, factory: :user_with_username
    end
    
    factory :private_wiki do
      association :user, factory: :premium_user
      private true
    end
  end
end