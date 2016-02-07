class AddPositionNameToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :position_name, :string

  end
end
