class CreateOrganizationAccounts < ActiveRecord::Migration
  def change
    create_table :organization_accounts do |t|
      t.integer :account_id
      t.integer :organization_id
      t.integer :anniversary_day
      t.integer :anniversary_month
      t.integer :anniversary_year
      t.integer :current_users, default: 0
      t.integer :current_candidates, default: 0

      t.timestamps
    end
  end
end
