class AddOptionsToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :min_age, :text
    add_column :campaigns, :max_age, :text
    add_column :campaigns, :gender, :text
    add_column :campaigns, :max_salary, :text
    add_column :campaigns, :civil_status, :text
  end
end
