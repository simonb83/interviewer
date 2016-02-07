class AddNameToCandidates < ActiveRecord::Migration
  def change
    add_column :candidates, :name, :string

  end
end
