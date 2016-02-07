class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.string :category
      t.string :section
      t.string :content
      t.string :interview_id

      t.timestamps
    end
  end
end
