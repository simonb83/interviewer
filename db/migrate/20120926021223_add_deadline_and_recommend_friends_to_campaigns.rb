class AddDeadlineAndRecommendFriendsToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :deadline, :date

    add_column :campaigns, :recommend_friends, :boolean

  end
end
