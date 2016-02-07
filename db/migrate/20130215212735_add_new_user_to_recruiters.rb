class AddNewUserToRecruiters < ActiveRecord::Migration
  def change
    add_column :recruiters, :new_user, :boolean, default: true
  end
end
