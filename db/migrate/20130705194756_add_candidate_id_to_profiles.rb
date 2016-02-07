class AddCandidateIdToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :candidate_id, :integer
  end
end
