#Define Candidates

FactoryGirl.define do

factory :organization do
  name "company"
  active "true"
  account
end

factory :admin do |n|
  sequence(:email) {|n| "email#{n}@factory.com" }
  password "foobarcat"
  password_confirmation { |u| u.password }
end

factory :recruiter do |n|
  sequence(:email) {|n| "email#{n}@factory.com" }
  name "string"
  password "foobarcat"
  password_confirmation { |u| u.password }
  organization
end

factory :campaign do
    position_name "string"
    deadline { Date.today() + 5.days }
    recommend_friends true
    candidate_references true
    active true
    recruiter
end

factory :candidate do
    sequence(:email) {|n| "email#{n}@factory.com"}
    name "string"
    surname "string"
    campaign
end

factory :issue do
  email "email@factory.com"
end

factory :category do
  name "category name"
end

factory :question do
  content "string"
  kind "text"
end

factory :answer do
  content "string"
  question_id 1
end

factory :message do
  interview_id "uniq-string"
  sender_name "string"
  recruiter
end

factory :email, class: OpenStruct do
    to "email-token"
    from "user@email.com"
    subject "email subject"
    body "Hello!"
    attachments {[]}

    trait :with_attachment do
    attachments {[
      ActionDispatch::Http::UploadedFile.new({
        filename: 'test.pdf',
        type: 'pdf',
        tempfile: File.new("#{File.expand_path File.dirname(__FILE__)}/fixtures/test.pdf")
      })
    ]}
  end
end

end
