class AddPrefectureCodeToArticles < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :prefecture_code, :integer
  end
end
