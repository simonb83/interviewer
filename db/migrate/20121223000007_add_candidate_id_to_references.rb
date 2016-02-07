class AddCandidateIdToReferences < ActiveRecord::Migration
  def change
    add_column :references, :candidate_id, :integer

  end
end
