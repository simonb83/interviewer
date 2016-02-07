class AddRecruiterIdToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :recruiter_id, :integer

  end
end
