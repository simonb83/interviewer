class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :internal_id
      t.string :name
      t.string :period
      t.integer :max_users
      t.integer :voice_questions
      t.integer :included_candidates
      t.decimal :monthly_price, :precision => 8, :scale => 2
      t.decimal :candidate_price, :precision => 8, :scale => 2

      t.timestamps
    end
  end
end
