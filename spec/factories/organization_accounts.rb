# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :organization_account do
    account_id 1
    organization_id 1
    anniversary_day 1
    anniversary_month 1
    anniversary_year 1
    current_users 1
    current_candidates 1
  end
end
