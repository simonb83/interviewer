class AddCompletedFilterInterviewToCandidates < ActiveRecord::Migration
  def change
    add_column :candidates, :completed_filter_interview, :boolean
  end
end
