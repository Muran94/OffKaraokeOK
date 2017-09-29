# frozen_string_literal: true
# == Schema Information
#
# Table name: inquiries
#
#  id              :integer          not null, primary key
#  inquirers_email :string
#  type            :integer
#  message         :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

# spec内で使われてるshared_examplesはこのファイル内で定義
require 'shared_examples/model_spec_shared_examples'

RSpec.describe Inquiry, type: :model do
  context 'バリデーション' do
    context '問い合わせ者のメールアドレス' do
      context 'presence検証' do
        it_behaves_like '空文字かnilの時はバリデーションに引っかかること' do
          let(:model_object) { :inquiry }
          let(:field_name) { :inquirers_email }
        end
      end
      context 'format検証' do
        let(:inquiry) { build(:inquiry, inquirers_email: inquirers_email) }

        context '正常系' do
          let(:inquirers_email) { 'sample@gmail.com' }
          it '通ること' do
            expect(inquiry.valid?).to be true
          end
        end

        context '異常系' do
          after do
            inquiry.valid?
            expect(inquiry.errors.messages[:inquirers_email]).to include('is invalid')
          end
          context '文字列の場合' do
            let(:inquirers_email) { 'something' }
            it 'バリデーションに引っかかること' do
            end
          end
          context '整数値の場合' do
            let(:inquirers_email) { 19_823 }
            it 'バリデーションに引っかかること' do
            end
          end
          context 'ローカル部が不正' do
            let(:inquirers_email) { 'Abc*@example.com' }
            it 'バリデーションに引っかかること' do
            end
          end
          context 'ドメイン部が不正' do
            let(:inquirers_email) { 'Abc*@@exa@mple.com' }
            it 'バリデーションに引っかかること' do
            end
          end
        end
      end
    end

    context '問い合わせの種類' do
      context 'inclusion検証' do
        after do
          inquiry.valid?
          expect(inquiry.errors.messages[:type]).to include('is not included in the list')
        end

        context 'nilが与えられた時' do
          let(:inquiry) { build(:inquiry, type: nil) }

          it 'バリデーションに引っかかること' do
          end
        end
        context '空文字が与えられた時' do
          let(:inquiry) { build(:inquiry, type: '') }

          it 'バリデーションに引っかかること' do
          end
        end
        context '文字列が与えられた時' do
          let(:inquiry) { build(:inquiry, type: 'something') }

          it 'バリデーションに引っかかること' do
          end
        end
        context 'リスト（0 ~ 2)以外の数値が与えられた時' do
          let(:inquiry) { build(:inquiry, type: 100) }

          it 'バリデーションに引っかかること' do
          end
        end
      end
    end

    context '問い合わせ本文' do
      context 'presence検証' do
        it_behaves_like '空文字かnilの時はバリデーションに引っかかること' do
          let(:model_object) { :inquiry }
          let(:field_name) { :message }
        end
      end

      context 'length検証(maximum)' do
        it_behaves_like '値の長さが上限値以下であれば通る' do
          let(:model_object) { :inquiry }
          let(:field_name) { :message }
          let(:max_length) { Inquiry::MESSAGE_MAXIMUM_LENGTH }
        end
        it_behaves_like '値の長さが上限値を超えていたらバリデーションに引っかかる' do
          let(:model_object) { :inquiry }
          let(:field_name) { :message }
          let(:max_length) { Inquiry::MESSAGE_MAXIMUM_LENGTH }
        end
      end
    end
  end
end
