class AddForwardApplicationsToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :forward_applications, :boolean, default:false
  end
end
