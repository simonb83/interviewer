class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|
      t.string :email
      t.integer :candidate_id

      t.timestamps
    end
  end
end
