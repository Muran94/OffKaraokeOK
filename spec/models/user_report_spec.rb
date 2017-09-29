# frozen_string_literal: true
# == Schema Information
#
# Table name: user_reports
#
#  id         :integer          not null, primary key
#  text       :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

require 'shared_examples/model_spec_shared_examples'

RSpec.describe UserReport, type: :model do
  context 'バリデーション' do
    context 'text' do
      context 'presence検証' do
        it_behaves_like '空文字かnilの時はバリデーションに引っかかること' do
          let(:model_object) { :user_report }
          let(:field_name) { :text }
        end
      end
      context 'length検証(maximum)' do
        it_behaves_like '値の長さが上限値以下であれば通る' do
          let(:model_object) { :user_report }
          let(:field_name) { :text }
          let(:max_length) { UserReport::TEXT_MAXIMUM_LENGTH }
        end
        it_behaves_like '値の長さが上限値を超えていたらバリデーションに引っかかる' do
          let(:model_object) { :user_report }
          let(:field_name) { :text }
          let(:max_length) { UserReport::TEXT_MAXIMUM_LENGTH }
        end
      end
    end
  end
end
