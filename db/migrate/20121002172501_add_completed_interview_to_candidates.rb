class AddCompletedInterviewToCandidates < ActiveRecord::Migration
  def change
    add_column :candidates, :completed_interview, :boolean, default: false

  end
end
