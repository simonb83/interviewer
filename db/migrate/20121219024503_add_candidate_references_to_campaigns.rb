class AddCandidateReferencesToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :candidate_references, :boolean

  end
end
