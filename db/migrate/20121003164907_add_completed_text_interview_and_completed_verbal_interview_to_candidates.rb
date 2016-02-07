class AddCompletedTextInterviewAndCompletedVerbalInterviewToCandidates < ActiveRecord::Migration
  def change
    add_column :candidates, :completed_text_interview, :boolean, default: false

    add_column :candidates, :completed_verbal_interview, :boolean, default: false

  end
end
