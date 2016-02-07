class AddLockableToRecruiters < ActiveRecord::Migration
  def change
    add_column :recruiters, :failed_attempts, :integer, default: 0
    add_column :recruiters, :unlock_token, :string
    add_column :recruiters, :locked_at, :datetime
  end
end
