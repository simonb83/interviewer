class AddCallSidAndCalledNumberToCandidates < ActiveRecord::Migration
  def change
    add_column :candidates, :call_sid, :string

    add_column :candidates, :called_number, :string

  end
end
