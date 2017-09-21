require 'rails_helper'

describe MessageDecorator, type: :decorator do
  context "#is_mine?" do
    # deviseのcurrent_userにアクセスできないため一旦PEND
  end

  context "#format_user_nickname" do
    subject { decorate(message).format_user_nickname }

    let(:user) {create(:user, nickname: "Paul McCartney")}
    let(:message) {create(:message)}

    context "会員のメッセージの場合" do
      let(:message) {create(:message, user_id: user.id)}

      it "そのユーザーのニックネームが表示されること" do
        expect(subject).to eq "Paul McCartney"
      end
    end

    context "名無しさんによるメッセージの場合" do
      let(:message) {create(:message, user_id: nil)}

      it "「名無しさん」と表示されること" do
        expect(subject).to eq "名無しさん"
      end
    end
  end
end
