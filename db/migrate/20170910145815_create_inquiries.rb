# frozen_string_literal: true
class CreateInquiries < ActiveRecord::Migration[5.1]
  def change
    create_table :inquiries do |t|
      t.string :inquirers_email
      t.integer :type
      t.text :message

      t.timestamps
    end
  end
end
