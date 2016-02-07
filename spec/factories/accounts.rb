# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account do
    sequence(:internal_id){|n| "ABC#{n}"}
    name "MyString"
    period "monthly"
    max_users 2
    voice_questions 1
    included_candidates 2
    monthly_price "9.99"
    candidate_price "9.99"
  end
end
