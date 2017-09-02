class AddArticleIdToParticipants < ActiveRecord::Migration[5.1]
  def change
    add_column :participants, :article_id, :integer
  end
end
