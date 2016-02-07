class AddReceiveApplicationsToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :receive_applications, :boolean, default: false
  end
end
