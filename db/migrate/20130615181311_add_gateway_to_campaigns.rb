class AddGatewayToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :gateway, :boolean
  end
end
