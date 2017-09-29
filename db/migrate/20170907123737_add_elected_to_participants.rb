# frozen_string_literal: true
class AddElectedToParticipants < ActiveRecord::Migration[5.1]
  def change
    add_column :participants, :elected, :boolean, default: false
  end
end
