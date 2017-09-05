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
require 'shared_examples/model_spec_shared_examples' # spec内で使われてるshared_examplesはこのファイル内で定義

RSpec.describe User, type: :model do
  context '関連付け' do
    context 'dependent' do
      let(:user) { create(:user) }

      context 'Article' do
        let!(:article) { create_list(:article, 2, user: user) }

        it 'userが削除されたらarticleも削除される' do
          expect { user.destroy }.to change(Article, :count).by(-2)
        end
      end

      context 'Participant' do
        let!(:participant) { create_list(:participant, 2, user: user) }

        it 'userが削除されたらarticleも削除される' do
          expect { user.destroy }.to change(Participant, :count).by(-2)
        end
      end
    end
  end

  context 'バリデーション' do
    context 'ニックネーム' do
      context 'presence検証' do
        it_behaves_like '空文字かnilの時はバリデーションに引っかかること' do
          let(:model_object) { :user }
          let(:field_name) { :nickname }
        end
      end

      context 'length検証(maximum)' do
        it_behaves_like '値の長さが上限値以下であれば通る' do
          let(:model_object) { :user }
          let(:field_name) { :nickname }
          let(:max_length) { User::NICKNAME_MAXIMUM_LENGTH }
        end
        it_behaves_like '値の長さが上限値を超えていたらバリデーションに引っかかる' do
          let(:model_object) { :user }
          let(:field_name) { :nickname }
          let(:max_length) { User::NICKNAME_MAXIMUM_LENGTH }
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
        context 'nil' do
          let(:sex) { nil }
          it '通ること' do
            expect(user).to be_valid
          end
        end
      end

      context '異常系' do
        context '空文字' do
          let(:sex) { '' }
          it '通ること' do
            user.valid?
            expect(user.errors.messages[:sex]).to match_array ['is not included in the list']
          end
        end
        context 'male or female 意外' do
          let(:sex) { 'other' }
          it '通ること' do
            user.valid?
            expect(user.errors.messages[:sex]).to match_array ['is not included in the list']
          end
        end
      end
    end

    context '自己紹介文' do
      let(:user) { build(:user, introduction: introduction) }
      context '正常値' do
        let(:introduction) { 'よろしくお願い致します！' }
        it '通ること' do
          expect(user).to be_valid
        end
      end
      context 'nil' do
        let(:introduction) { nil }
        it '通ること' do
          expect(user).to be_valid
        end
      end
      context 'length検証(maximum)' do
        it_behaves_like '値の長さが上限値以下であれば通る' do
          let(:model_object) { :user }
          let(:field_name) { :introduction }
          let(:max_length) { User::INTRODUCTION_MAXIMUM_LENGTH }
        end
        it_behaves_like '値の長さが上限値を超えていたらバリデーションに引っかかる' do
          let(:model_object) { :user }
          let(:field_name) { :introduction }
          let(:max_length) { User::INTRODUCTION_MAXIMUM_LENGTH }
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
