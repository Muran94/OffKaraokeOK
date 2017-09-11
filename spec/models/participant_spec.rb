# == Schema Information
#
# Table name: participants
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  article_id :integer
#  elected    :boolean          default(FALSE)
#

require 'rails_helper'

RSpec.describe Participant, type: :model do
  context 'バリデーション' do
    context 'article_idが存在しない' do
      let(:participant) { build(:participant, article_id: nil) }
      it 'バリデーションに引っかかること' do
        participant.valid?
        expect(participant.errors.messages[:article_id]).to match_array(["can't be blank"])
      end
    end
    context 'user_idが存在しない' do
      let(:participant) { build(:participant, user_id: nil) }
      it 'バリデーションに引っかかること' do
        participant.valid?
        expect(participant.errors.messages[:user_id]).to match_array(["can't be blank"])
      end
    end
  end
end
