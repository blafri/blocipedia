FactoryGirl.define do
  factory :wiki do
    user
    title "Wiki Title"
    body "Wiki body"
    
    factory :wiki_user_has_username do
      association :user, factory: :user_with_username
    end
  end
end