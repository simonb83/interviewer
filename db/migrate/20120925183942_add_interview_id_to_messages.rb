class AddInterviewIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :interview_id, :string

  end
end
