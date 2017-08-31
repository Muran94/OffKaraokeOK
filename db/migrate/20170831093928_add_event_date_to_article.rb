class AddEventDateToArticle < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :event_date, :integer
  end
end
