class AddCampaignIdToCandidates < ActiveRecord::Migration
  def up
    add_column :candidates, :campaign_id, :integer
  end

  def down
    remove_column :candidates, :campaign_id
  end
end
