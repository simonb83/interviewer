class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :name
      t.string :surname_paternal
      t.string :surname_maternal
      t.date :dob
      t.string :gender
      t.string :estado_civil
      t.string :desired_salary

      t.timestamps
    end
  end
end
