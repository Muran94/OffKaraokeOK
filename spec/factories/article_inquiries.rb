# == Schema Information
#
# Table name: article_inquiries
#
#  id         :integer          not null, primary key
#  text       :text
#  user_id    :integer
#  article_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :article_inquiry, class: 'Article::Inquiry' do
    text 'MyText'
    user_id 1
    article_id 1
  end
end
