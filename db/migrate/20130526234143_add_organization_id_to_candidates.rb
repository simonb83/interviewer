class AddOrganizationIdToCandidates < ActiveRecord::Migration
  def change
    add_column :candidates, :organization_id, :integer
  end
end
