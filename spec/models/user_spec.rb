# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  introduction           :text
#  sex                    :string
#  birthday               :date
#  nickname               :string
#

require 'rails_helper'

RSpec.describe User, type: :model do
  context 'バリデーション' do
    context 'ニックネーム' do
      let(:user) { create(:user, nickname: nickname) }
      context '正常系' do
        let(:nickname) { Faker::Name.name }
        it '通ること' do
          expect(user).to be_valid
        end
      end
      context '異常系' do
        context '空' do
        end
      end
    end
  end
end
