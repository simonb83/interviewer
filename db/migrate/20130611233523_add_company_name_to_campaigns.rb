class AddCompanyNameToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :company_name, :string
  end
end
