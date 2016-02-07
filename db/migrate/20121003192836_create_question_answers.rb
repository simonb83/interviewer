class CreateQuestionAnswers < ActiveRecord::Migration
  def change
    create_table :question_answers do |t|
      t.integer :question_id
      t.integer :answer_id

      t.timestamps
    end
    add_index :question_answers, :question_id
    add_index :question_answers, :answer_id
  end
end
