class AddActiveToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :active, :boolean, default: true
  end
end
