# frozen_string_literal: true
class DeletePrefectureIdFromArticles < ActiveRecord::Migration[5.1]
  def change
    remove_column :articles, :prefecture_id, :integer
  end
end
