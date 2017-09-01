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

require 'rails_helper'

RSpec.describe Article::Inquiry, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
