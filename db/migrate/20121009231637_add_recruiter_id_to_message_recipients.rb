class AddRecruiterIdToMessageRecipients < ActiveRecord::Migration
  def change
    add_column :message_recipients, :recruiter_id, :integer

  end
end
