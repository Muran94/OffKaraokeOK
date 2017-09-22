# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_170_921_122_147) do
  create_table 'articles', force: :cascade do |t|
    t.string 'title'
    t.text 'text'
    t.datetime 'application_period'
    t.integer 'capacity'
    t.string 'venue'
    t.integer 'participation_cost'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.datetime 'event_date'
    t.integer 'user_id'
    t.integer 'prefecture_code'
  end

  create_table 'favorites', force: :cascade do |t|
    t.integer 'article_id'
    t.integer 'user_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['article_id'], name: 'index_favorites_on_article_id'
    t.index ['user_id'], name: 'index_favorites_on_user_id'
  end

  create_table 'inquiries', force: :cascade do |t|
    t.string 'inquirers_email'
    t.integer 'type'
    t.text 'message'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'messages', force: :cascade do |t|
    t.text 'text'
    t.integer 'read_count'
    t.integer 'article_id'
    t.integer 'user_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['article_id'], name: 'index_messages_on_article_id'
    t.index ['user_id'], name: 'index_messages_on_user_id'
  end

  create_table 'participants', force: :cascade do |t|
    t.integer 'user_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'article_id'
    t.boolean 'elected', default: false
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.integer 'sign_in_count', default: 0, null: false
    t.datetime 'current_sign_in_at'
    t.datetime 'last_sign_in_at'
    t.string 'current_sign_in_ip'
    t.string 'last_sign_in_ip'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.text 'introduction'
    t.string 'sex'
    t.date 'birthday'
    t.string 'nickname'
    t.string 'image'
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
  end
end
