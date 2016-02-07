class AddCandidateIdToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :candidate_id, :integer

  end
end
