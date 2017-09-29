# frozen_string_literal: true
class AddSeveralColumnsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :introduction, :text
    add_column :users, :sex, :string
    add_column :users, :birthday, :date
  end
end
