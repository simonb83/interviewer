class CreateMessageRecipients < ActiveRecord::Migration
  def change
    create_table :message_recipients do |t|
      t.string :email
      t.integer :message_id

      t.timestamps
    end
  end
end
