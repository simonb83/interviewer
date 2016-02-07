class AddAcceptedAndRejectedToCandidates < ActiveRecord::Migration
  def change
    add_column :candidates, :accepted, :boolean, default: false

    add_column :candidates, :rejected, :boolean, default: false

  end
end
