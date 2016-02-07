class AddInterviewCompletedAtToCandidates < ActiveRecord::Migration
  def change
    add_column :candidates, :interview_completed_at, :datetime

  end
end
