class AddCelToCandidates < ActiveRecord::Migration
  def change
    add_column :candidates, :cel, :string, default: nil
  end
end
