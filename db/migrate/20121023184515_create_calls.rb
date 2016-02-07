class CreateCalls < ActiveRecord::Migration
  def change
    create_table :calls do |t|
      t.string :sid
      t.string :status
      t.integer :candidate_id

      t.timestamps
    end
  end
end
