class AddAdditionalCandidatesToOrganizationAccount < ActiveRecord::Migration
  def change
    add_column :organization_accounts, :additional_candidates, :integer, default: 0
  end
end
