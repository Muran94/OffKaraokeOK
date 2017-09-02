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
      let(:user) { build(:user, nickname: nickname) }
      context '正常系' do
        let(:nickname) { 'かかかかかかかし' }
        it '通ること' do
          expect(user).to be_valid
        end
      end
      context '異常系' do
        context '空' do
          let(:nickname) { nil }
          it 'バリデーションに引っかかること' do
            user.valid?
            expect(user.errors.messages[:nickname]).to match_array "can't be blank"
          end
        end
        context "#{User::NICKNAME_MAXIMUM_LENGTH}字を超える" do
          let(:nickname) { 'a' * (User::NICKNAME_MAXIMUM_LENGTH + 1) }
          it 'バリデーションに引っかかること' do
            user.valid?
            expect(user.errors.messages[:nickname]).to match_array "is too long (maximum is #{User::NICKNAME_MAXIMUM_LENGTH} characters)"
          end
        end
      end
    end

    context '生年月日' do
      let(:user) { build(:user, birthday: birthday) }
      context '正常系' do
        context '正常値' do
          let(:birthday) { 15.years.ago.to_date }
          it '通ること' do
            expect(user).to be_valid
          end
        end
        context '空' do
          let(:birthday) { nil }
          it '通ること' do
            expect(user).to be_valid
          end
        end
      end
    end

    context '性別' do
      let(:user) { build(:user, sex: sex) }
      context '正常系' do
        context '正常値' do
          let(:sex) { 'male' }
          it '通ること' do
            expect(user).to be_valid
          end
        end
        context '空' do
          let(:sex) { nil }
          it '通ること' do
            expect(user).to be_valid
          end
        end
      end
      context '異常系' do
        context 'male or female 意外' do
          let(:sex) { 'other' }
          it '通ること' do
            user.valid?
            expect(user.errors.messages[:sex]).to match_array 'is not included in the list'
          end
        end
      end
    end

    context '自己紹介文' do
      let(:user) { build(:user, introduction: introduction) }
      context '正常系' do
        context '正常値' do
          let(:introduction) { 'よろしくお願い致します！' }
          it '通ること' do
            expect(user).to be_valid
          end
        end
        context '空' do
          let(:introduction) { nil }
          it '通ること' do
            expect(user).to be_valid
          end
        end
      end
      context '異常系' do
        context "#{User::INTRODUCTION_MAXIMUM_LENGTH}字を超える" do
          let(:introduction) { 'a' * (User::INTRODUCTION_MAXIMUM_LENGTH + 1) }
          it '通ること' do
            user.valid?
            expect(user.errors.messages[:introduction]).to match_array "is too long (maximum is #{User::INTRODUCTION_MAXIMUM_LENGTH} characters)"
          end
        end
      end
    end

    context '#owner?(model_object)' do
      let(:user) { create(:user) }

      context '正常系' do
        let(:owner_article) { create(:article, user_id: user.id) }
        let(:not_owner_article) { create(:article) }

        context 'オブジェクトオーナーである場合' do
          it 'trueが返ること' do
            expect(user.owner?(owner_article)).to eq true
          end
        end
        context 'オブジェクトオーナーでない場合' do
          it 'falseが返ること' do
            expect(user.owner?(not_owner_article)).to eq false
          end
        end
      end

      context '異常系' do
        context 'オブジェクトが存在しない場合' do
          let(:article) { nil }
          it 'falseが返ること' do
            expect(user.owner?(article)).to eq false
          end
        end

        context 'user_idフィールドを持たないオブジェクトの場合' do
          let(:date) { Date.new }
          it 'falseが返ること' do
            expect(user.owner?(date)).to eq false
          end
        end
      end
    end

    context '#not_owner?(model_object)' do
      let(:user) { create(:user) }

      context '正常系' do
        let(:owner_article) { create(:article, user_id: user.id) }
        let(:not_owner_article) { create(:article) }

        context 'オブジェクトオーナーである場合' do
          it 'falseが返ること' do
            expect(user.not_owner?(owner_article)).to eq false
          end
        end
        context 'オブジェクトオーナーでない場合' do
          it 'trueが返ること' do
            expect(user.not_owner?(not_owner_article)).to eq true
          end
        end
      end

      context '異常系' do
        context 'オブジェクトが存在しない場合' do
          let(:article) { nil }
          it 'trueが返ること' do
            expect(user.not_owner?(article)).to eq true
          end
        end

        context 'user_idフィールドを持たないオブジェクトの場合' do
          let(:date) { Date.new }
          it 'trueが返ること' do
            expect(user.not_owner?(date)).to eq true
          end
        end
      end
    end

    context '#already_participated?(article)' do
      let(:user) { create(:user) }
      let(:article) { create(:article) }

      context '正常系' do
        context '参加済みだった場合' do
          let!(:partipants) { create(:participant, user: user, article: article) }
          it 'trueが返ること' do
            expect(user.already_participated?(article)).to eq true
          end
        end

        context 'まだ参加していなかった場合' do
          it 'falseが返ること' do
            expect(user.already_participated?(article)).to eq false
          end
        end
      end

      context '異常系' do
        context '渡されたarticleが空' do
          let(:article) { nil }
          it 'falseが返ること' do
            expect(user.already_participated?(article)).to eq false
          end
        end
      end
    end
  end
end
