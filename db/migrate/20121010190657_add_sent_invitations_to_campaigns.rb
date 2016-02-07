class AddSentInvitationsToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :sent_invitations, :integer, default: 0

  end
end
