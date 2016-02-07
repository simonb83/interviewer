# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :profile do
    name "MyString"
    surname_paternal "MyString"
    surname_maternal "MyString"
    dob "2013-07-04"
    gender "MyString"
    estado_civil "MyString"
    desired_salary "MyString"
  end
end
