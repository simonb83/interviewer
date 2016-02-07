class AddUidToCandidates < ActiveRecord::Migration
  def change
    add_column :candidates, :uid, :string

  end
end
