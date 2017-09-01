class CreateArticleInquiries < ActiveRecord::Migration[5.1]
  def change
    create_table :article_inquiries do |t|
      t.text :text
      t.integer :user_id
      t.integer :article_id

      t.timestamps
    end
  end
end
