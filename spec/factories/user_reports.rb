FactoryGirl.define do
  factory :user_report do
    association :user

    text '通報しますた'
  end
end
