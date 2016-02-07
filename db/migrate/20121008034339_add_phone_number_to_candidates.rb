class AddPhoneNumberToCandidates < ActiveRecord::Migration
  def change
    add_column :candidates, :phone_number, :string

  end
end
