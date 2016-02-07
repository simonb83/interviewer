class AddRecommendedFriendsToCandidates < ActiveRecord::Migration
  def change
    add_column :candidates, :recommended_friends, :string

  end
end
