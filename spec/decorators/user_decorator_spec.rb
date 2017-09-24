require 'rails_helper'

describe UserDecorator do
  let(:user) { User.new.extend UserDecorator }
  subject { user }
  it { should be_a User }

  context "#format_sex" do
    let(:user) {create(:user, sex: sex)}
    subject { decorate(user).format_sex }

    context "設定されている場合" do
      let(:sex) { "male" }
      it "設定値が返ってくること" do
        expect(subject).to eq sex
      end
    end
    context "設定されていない場合" do
      let(:sex) { nil }
      it "「未設定」という文字列が返ってくること" do
        expect(subject).to eq "未設定"
      end
    end
  end

  context "#format_birthday" do
    let(:user) {create(:user, birthday: birthday)}
    subject { decorate(user).format_birthday }

    context "設定されている場合" do
      let(:birthday) { 18.years.ago.to_date }
      it "設定値が返ってくること" do
        expect(subject).to eq birthday
      end
    end
    context "設定されていない場合" do
      let(:birthday) { nil }
      it "「未設定」という文字列が返ってくること" do
        expect(subject).to eq "未設定"
      end
    end
  end

  context "#format_introduction" do
    let(:user) {create(:user, introduction: introduction)}
    subject { decorate(user).format_introduction }

    context "設定されている場合" do
      let(:introduction) { "よろしくお願いいたします。" }
      it "設定値が返ってくること" do
        expect(subject).to eq introduction
      end
    end
    context "設定されていない場合" do
      let(:introduction) { nil }
      it "「未設定」という文字列が返ってくること" do
        expect(subject).to eq "未設定"
      end
    end
  end
end
