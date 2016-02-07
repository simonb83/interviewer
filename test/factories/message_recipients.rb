# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message_recipient do
    email "MyString"
    message_id 1
  end
end
