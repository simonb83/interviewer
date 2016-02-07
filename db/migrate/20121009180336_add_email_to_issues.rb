class AddEmailToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :email, :string

  end
end
