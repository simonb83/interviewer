class RemoveCategoryFromQuestions < ActiveRecord::Migration
  def up
    remove_column :questions, :category
      end

  def down
    add_column :questions, :category, :string
  end
end
