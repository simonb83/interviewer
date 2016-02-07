class AddRelationshipToReferences < ActiveRecord::Migration
  def change
    add_column :references, :relationship, :string

  end
end
