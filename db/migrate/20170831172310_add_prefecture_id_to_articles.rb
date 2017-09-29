# frozen_string_literal: true
class AddPrefectureIdToArticles < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :prefecture_id, :integer
  end
end
