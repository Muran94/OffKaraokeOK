# == Schema Information
#
# Table name: participants
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :participant do
    user_id 1
  end
end
