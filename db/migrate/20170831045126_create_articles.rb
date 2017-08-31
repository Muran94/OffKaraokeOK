class CreateArticles < ActiveRecord::Migration[5.1]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :text
      t.datetime :application_period
      t.integer :capacity
      t.string :venue
      t.integer :budget

      t.timestamps
    end
  end
end