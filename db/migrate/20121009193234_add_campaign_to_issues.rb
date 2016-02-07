class AddCampaignToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :campaign_id, :integer

  end
end
