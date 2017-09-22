require 'rails_helper'
require 'shared_examples/model_spec_shared_examples' # spec内で使われてるshared_examplesはこのファイル内で定義

RSpec.describe Message, type: :model do
  context 'text' do
    context 'length検証(maximum)' do
      it_behaves_like '値の長さが上限値以下であれば通る' do
        let(:model_object) { :message }
        let(:field_name) { :text }
        let(:max_length) { Message::TEXT_MAXIMUM_LENGTH }
      end
      it_behaves_like '値の長さが上限値を超えていたらバリデーションに引っかかる' do
        let(:model_object) { :message }
        let(:field_name) { :text }
        let(:max_length) { Message::TEXT_MAXIMUM_LENGTH }
      end
    end
  end

  # メッセージ投稿主のUserオブジェクトを返す
  context '#owner' do
    let(:user) { create(:user) }
    let(:message) { create(:message, user_id: user_id) }

    context '会員によるメッセージである場合' do
      let(:user_id) { user.id }
      it 'メッセージオーナーのUserオブジェクトが返ってくること' do
        expect(message.owner).to eq user
      end
    end
    context '名無しさんによるメッセージである場合' do
      let(:user_id) { nil }
      it 'nilを返すこと' do
        expect(message.owner).to eq nil
      end
    end
  end
end
