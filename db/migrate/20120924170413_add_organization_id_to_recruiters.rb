class AddOrganizationIdToRecruiters < ActiveRecord::Migration
  def change
    add_column :recruiters, :organization_id, :integer

  end
end
