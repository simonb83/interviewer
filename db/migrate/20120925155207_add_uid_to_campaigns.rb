class AddUidToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :uid, :string, unique: true

  end
end
