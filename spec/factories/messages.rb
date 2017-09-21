FactoryGirl.define do
  factory :message do
    sequence :text do |num|
      "メッセージ本文#{num}"
    end
    association :article
  end
end
