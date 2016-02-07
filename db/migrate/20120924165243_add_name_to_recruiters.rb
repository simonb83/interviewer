class AddNameToRecruiters < ActiveRecord::Migration
  def change
    add_column :recruiters, :name, :string, first: true
  end
end
