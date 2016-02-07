class AddRecruiterIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :recruiter_id, :integer

  end
end
