class AddSurnameToCandidates < ActiveRecord::Migration
  def change
    add_column :candidates, :surname, :string

  end
end
