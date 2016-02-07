class AddRecruiterTypeToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :recruiter_type, :string

  end
end
