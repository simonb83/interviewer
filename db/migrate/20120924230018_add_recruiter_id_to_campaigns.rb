class AddRecruiterIdToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :recruiter_id, :integer

  end
end
