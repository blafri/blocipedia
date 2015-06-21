FactoryGirl.define do
  factory :colaborator do
    user
    association :wiki, factory: :private_wiki
  end
end